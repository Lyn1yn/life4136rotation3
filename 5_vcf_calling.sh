#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=vcf_chr
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --array=1-38%10
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/logs/vcf_chr_%A_%a.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/logs/vcf_chr_%A_%a.err

set -eo pipefail

source $HOME/.bash_profile
conda activate bioinfo

REF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/data/reference/UU_Cfam_GSD_1.0/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna
BAM_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering/bam_list.txt
CHR_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/chr_list.txt
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/by_chr

mkdir -p "$OUT_DIR"

CHR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$CHR_LIST")

echo "Task ID: ${SLURM_ARRAY_TASK_ID}"
echo "Chromosome: ${CHR}"

bcftools mpileup \
    --threads "${SLURM_CPUS_PER_TASK}" \
    -r "$CHR" \
    -f "$REF" \
    -b "$BAM_LIST" \
    -Ou | \
bcftools call \
    --threads "${SLURM_CPUS_PER_TASK}" \
    -mv \
    -Oz \
    -o "${OUT_DIR}/${CHR}.vcf.gz"

bcftools index "${OUT_DIR}/${CHR}.vcf.gz"

echo "Finished ${CHR}”


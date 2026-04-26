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

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate bioinfo

# Define path of the reference genome.
REF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/data/reference/UU_Cfam_GSD_1.0/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna
# Define path of the BAM list containing filtered BAM files for variant calling.
BAM_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering/bam_list.txt
# Define path of the chromosome list to be processed by the SLURM array.
CHR_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/chr_list.txt
# Define output directory for per-chromosome VCF files.
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/by_chr

mkdir -p "$OUT_DIR"

# Extract the chromosome name from the chromosome files.
CHR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$CHR_LIST")

# Generate genotype likelihoods for the selected chromosome, then call variants and output a compressed VCF file.
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

# Index the compressed VCF file for downstream analysis.
bcftools index "${OUT_DIR}/${CHR}.vcf.gz"

# Print completion message to the log file.
echo "Finished ${CHR}”


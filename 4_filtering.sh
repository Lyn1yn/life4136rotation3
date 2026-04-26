#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=samfilter
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --array=1-101%10
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering/logs/samfilter_%A_%a.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering/logs/samfilter_%A_%a.err

set -eo pipefail

source $HOME/.bash_profile
conda activate bioinfo

INPUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering
SAMPLE_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/good_bams.txt

mkdir -p "$OUT_DIR"

sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

inbam=${INPUT_DIR}/${sample}.sorted.bam
tmpbam=${OUT_DIR}/${sample}.filtered.bam
outbam=${OUT_DIR}/${sample}.filtered.sorted.bam

echo "Task ID: ${SLURM_ARRAY_TASK_ID}"
echo "Sample: ${sample}"

[[ -f "$inbam" ]] || { echo "Missing file: $inbam"; exit 1; }

samtools view \
    -@ "${SLURM_CPUS_PER_TASK}" \
    -b \
    -q 20 \
    -F 2308 \
    "$inbam" > "$tmpbam"

samtools sort \
    -@ "${SLURM_CPUS_PER_TASK}" \
    -o "$outbam" \
    "$tmpbam"

samtools index "$outbam"

rm -f "$tmpbam"

echo "Finished ${sample}"


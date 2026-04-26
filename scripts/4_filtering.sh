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

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate bioinfo

# Define input directory containing sorted BAM files from the mapping step.
INPUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping
# Define output directory for filtered BAM files.
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/4_filtering
# Define path of sample names to be processed.
SAMPLE_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/good_bams.txt

mkdir -p "$OUT_DIR"

# Extract the sample name corresponding to the current SLURM array task.
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

# Define input BAM file, temporary filtered BAM file, and final sorted filtered BAM file.
inbam=${INPUT_DIR}/${sample}.sorted.bam
tmpbam=${OUT_DIR}/${sample}.filtered.bam
outbam=${OUT_DIR}/${sample}.filtered.sorted.bam

# Check whether the input BAM file exists before running filtering.
[[ -f "$inbam" ]] || { echo "Missing file: $inbam"; exit 1; }

# Filter BAM file by keeping reads with mapping quality >= 20 and removing unwanted alignments.
samtools view \
    -@ "${SLURM_CPUS_PER_TASK}" \
    -b \
    -q 20 \
    -F 2308 \
    "$inbam" > "$tmpbam"

# Sort the filtered BAM file by genomic coordinates.
samtools sort \
    -@ "${SLURM_CPUS_PER_TASK}" \
    -o "$outbam" \
    "$tmpbam"

# Index the sorted filtered BAM file, and generate bai files.
samtools index "$outbam"

# Remove the temporary BAM file to save storage space.
rm -f "$tmpbam"

# Print completion message to the log file.
echo "Finished ${sample}"


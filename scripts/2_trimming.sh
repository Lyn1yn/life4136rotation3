#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=fastp
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --array=1-115%10
#SBATCH --output=fastp_%A_%a.out
#SBATCH --error=fastp_%A_%a.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate bioinfo

# Define input directory.
INPUT_DIR=/gpfs01/share/BioinfMSc/Hannah_resources/doggies/fastqs
# Define output directory.
OUTPUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/2_trimming
# Define report output directory.
REPORT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/2_trimming
# Define path of sample names to be processed.
SAMPLE_LIST=/gpfs01/home/mbxll1/rotation3/dog/3_mapping/samples.txt

mkdir -p "$OUTPUT_DIR"
mkdir -p "$REPORT_DIR"

# Extract the sample names to be processed from the sample files.
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

# Input paired-end sequencing files.
r1=${INPUT_DIR}/${sample}_1.fastq.gz
r2=${INPUT_DIR}/${sample}_2.fastq.gz

#Output the trimmed FASTQ files and report.
out1=${OUTPUT_DIR}/${sample}_1.trimmed.fastq.gz
out2=${OUTPUT_DIR}/${sample}_2.trimmed.fastq.gz
html=${REPORT_DIR}/${sample}.fastp.html
json=${REPORT_DIR}/${sample}.fastp.json

# Check if input files exist.
[[ -f "$r1" ]] || { echo "Missing file: $r1"; exit 1; }
[[ -f "$r2" ]] || { echo "Missing file: $r2"; exit 1; }

# Run fastp, output the trimmed FASTQ files and report.
fastp \
    -i "$r1" \
    -I "$r2" \
    -o "$out1" \
    -O "$out2" \
    --detect_adapter_for_pe \
    --thread "${SLURM_CPUS_PER_TASK}" \
    --html "$html" \
    --json "$json"


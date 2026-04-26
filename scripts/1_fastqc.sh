#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=fastqc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=fastqc.%j.out
#SBATCH --error=fastqc.%j.err

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate qc

# Define input directory.
INPUT_DIR=/gpfs01/share/BioinfMSc/Hannah_resources/doggies/fastqs
# Define output directory.
OUTPUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/1_qc

mkdir -p $OUTPUT_DIR

# Run fastqc, output: html report for each file.
fastqc -t 8 $INPUT_DIR/*.fastq.gz -o $OUTPUT_DIR


#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=bwa_map
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --array=1-10%10
#SBATCH --output=logs/bwa_%A_%a.out
#SBATCH --error=logs/bwa_%A_%a.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate bioinfo

# Define fastq input directory.
FASTQ_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/2_trimming
# Define path of reference.
REF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/UU_Cfam_GSD_1.0/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna
# Define the path of samples failed to generate BAM files.
SAMPLE_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/missing_bam.txt
# Define output directory.
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping

mkdir -p $OUT_DIR
mkdir -p logs

# Read the sample name corresponding to the current SLURM array task from the sample list file.
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $SAMPLE_LIST)

# Input paired-end sequencing files.
R1=${FASTQ_DIR}/${SAMPLE}_1.trimmed.fastq.gz
R2=${FASTQ_DIR}/${SAMPLE}_2.trimmed.fastq.gz
# Define the path and filename for the output BAM file.
BAM=${OUT_DIR}/${SAMPLE}.sorted.bam


# Run mapping and generate BAM files.
bwa mem -t ${SLURM_CPUS_PER_TASK} $REF $R1 $R2 | \
    samtools view -@ ${SLURM_CPUS_PER_TASK} -b | \
    samtools sort -@ ${SLURM_CPUS_PER_TASK} -o $BAM

# Index the sorted BAM file, and generate bam and bai files.
samtools index $BAM


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

set -eo pipefail

source $HOME/.bash_profile
conda activate bioinfo

FASTQ_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/2_trimming
REF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/UU_Cfam_GSD_1.0/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna
SAMPLE_LIST=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping/missing_bam.txt
OUT_DIR=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/3_mapping

mkdir -p $OUT_DIR
mkdir -p logs

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $SAMPLE_LIST)

R1=${FASTQ_DIR}/${SAMPLE}_1.trimmed.fastq.gz
R2=${FASTQ_DIR}/${SAMPLE}_2.trimmed.fastq.gz
BAM=${OUT_DIR}/${SAMPLE}.sorted.bam

bwa mem -t ${SLURM_CPUS_PER_TASK} $REF $R1 $R2 | \
    samtools view -@ ${SLURM_CPUS_PER_TASK} -b | \
    samtools sort -@ ${SLURM_CPUS_PER_TASK} -o $BAM

samtools index $BAM


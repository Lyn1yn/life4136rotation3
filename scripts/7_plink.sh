#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=plink
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/7/rename/logs/plink.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/7/rename/logs/plink.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate gwas_env

# Convert the cleaned VCF file into PLINK binary format for GWAS analysis.
plink --vcf /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/dog_snps.renamed.vcf.gz --double-id --allow-extra-chr --make-bed --out dog_raw


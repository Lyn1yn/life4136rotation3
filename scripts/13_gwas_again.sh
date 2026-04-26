#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=gwas
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/13_gwas_again/logs/gwas.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/13_gwas_again/logs/gwas.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate gwas_env

# Run GWAS using PLINK linear regression with the first 20 PCA components as covariates.
plink --bfile /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/9_QC/dog_qc --allow-extra-chr --allow-no-sex --pheno /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/8_phenotype/pheno_ave_height.txt --covar /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/12_PCA/pca20.eigenvec --covar-number 1-20 --linear --out gwas_ave_height_pca3

#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=pca
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/12_PCA/logs/pca.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/12_PCA/logs/pca.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate gwas_env

# Calculate the first 20 principal components using LD-pruned SNPs.
plink --bfile /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/9_QC/dog_qc --allow-extra-chr --extract /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/11_LD_pruning/prune.prune.in --pca 20 --out pca20

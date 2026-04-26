#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=pruning
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/11_pruning/logs/gwas.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/11_pruning/logs/gwas.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate gwas_env

# Perform LD pruning to select approximately independent SNPs for PCA analysis.
plink --bfile /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/9_QC/dog_qc --allow-extra-chr --indep-pairwise 50 5 0.2 --out prune

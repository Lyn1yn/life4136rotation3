#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=qc
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/9_QC/logs/qc.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/9_QC/logs/qc.err

set -eo pipefail

source $HOME/.bash_profile
conda activate gwas_env


plink --bfile /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/7/renamed/dog_raw --allow-extra-chr --geno 0.3 --mind 0.6 --maf 0.5 --make-bed --out dog_qc

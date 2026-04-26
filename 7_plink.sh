#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=plink
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/7/rename/logs/plink.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/7/rename/logs/plink.err

set -eo pipefail

source $HOME/.bash_profile
conda activate gwas_env

plink --vcf /gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/dog_snps.renamed.vcf.gz --double-id --allow-extra-chr --make-bed --out dog_raw


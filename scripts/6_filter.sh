#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=filter
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/logs/filter.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/logs/filter.err

# Stop execution if any command fails.
set -eo pipefail

# Avoid the "conda command not found" error.
source $HOME/.bash_profile
# Activate conda environment.
conda activate bioinfo

# Define input VCF file containing variants from all autosomes.
VCF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/all_samples.autosomes.vcf.gz

# Filter variants by removing sites with QUAL < 30 or total depth DP < 10.
bcftools filter -e 'QUAL<30 || INFO/DP<10' $VCF -Oz -o filtered.vcf.gz

# Keep only biallelic SNPs and remove non-SNP or multi-allelic variants.
bcftools view -m2 -M2 -v snps filtered.vcf.gz -Oz -o dog_snps.vcf.gz

# Index the filtered SNP VCF file for downstream analysis.
bcftools index dog_snps.vcf.gz

#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --job-name=filter
#SBATCH --output=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/logs/filter.out
#SBATCH --error=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/6_clean_up/logs/filter.err

set -eo pipefail

source $HOME/.bash_profile
conda activate bioinfo

VCF=/gpfs01/share/BioinfMSc/life4136_2526/rotation3/group1/LL/dog/5_vcf/all_samples.autosomes.vcf.gz

# Filter: QUAL >=30 and DP >=10
bcftools filter -e 'QUAL<30 || INFO/DP<10' $VCF -Oz -o filtered.vcf.gz

# Keep only biallelic SNPs
bcftools view -m2 -M2 -v snps filtered.vcf.gz -Oz -o dog_snps.vcf.gz

#vcf index
bcftools index dog_snps.vcf.gz

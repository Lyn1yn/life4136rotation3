# LIFE4136 Rotation 3 Dog GWAS Pipeline

This repository contains scripts for a dog whole-genome sequencing analysis pipeline. The workflow starts from raw paired-end FASTQ files, performs read quality control, trimming, mapping, BAM filtering, variant calling, SNP filtering, conversion to PLINK format, genotype quality control, LD pruning, PCA, and GWAS for average height.

## Installation instruction

### 1. Clone the repository

```bash
git clone https://github.com/Lyn1yn/life4136rotation3.git
cd life4136rotation3
```

### 2. Create Conda environments

Three Conda environments are used in the scripts: `qc`, `bioinfo`, and `gwas_env`.

Example installation commands:

```bash
conda create -n qc -c bioconda -c conda-forge fastqc=0.12.1
conda create -n bioinfo -c bioconda -c conda-forge fastp=0.23.4 bwa=0.7.17 samtools=1.19.2 bcftools=1.19
conda create -n gwas_env -c bioconda -c conda-forge plink=1.90b6.26
```
The freezed python package list is under `requirements` folder.

## Input data

<!-- Fill this section later. -->

## Usage

The scripts should be run in numerical order. Each step generates files that are used by later steps in the pipeline.

### 1. Raw read quality control

Script:

```bash
scripts/1_fastqc.sh
```

Run FastQC on the raw FASTQ files to assess sequencing quality.

```bash
sbatch scripts/1_fastqc.sh
```

Main output:

- FastQC HTML reports
- FastQC ZIP result files

### 2. Read trimming and adapter removal

Script:

```bash
scripts/2_trimming.sh
```

Run fastp to trim adapters and filter low-quality reads from paired-end FASTQ files.

```bash
sbatch scripts/2_trimming.sh
```

Main output:

- Trimmed FASTQ files: `*_1.trimmed.fastq.gz` and `*_2.trimmed.fastq.gz`
- fastp HTML reports
- fastp JSON reports

### 3. Read mapping

Script:

```bash
scripts/3_mapping.sh
```

Map trimmed reads to the reference genome using BWA-MEM, convert SAM to BAM, sort the BAM file, and create a BAM index.

```bash
sbatch scripts/3_mapping.sh
```

Main output:

- Sorted BAM files: `*.sorted.bam`
- BAM index files: `*.sorted.bam.bai`

### 4. BAM filtering

Script:

```bash
scripts/4_filtering.sh
```

Filter BAM files using samtools. This step keeps reads with sufficient mapping quality and removes unwanted alignments.

```bash
sbatch scripts/4_filtering.sh
```

Main output:

- Filtered and sorted BAM files: `*.filtered.sorted.bam`
- BAM index files: `*.filtered.sorted.bam.bai`

### 5. Variant calling

Script:

```bash
scripts/5_vcf_calling.sh
```

Call variants by chromosome using bcftools mpileup and bcftools call.

```bash
sbatch scripts/5_vcf_calling.sh
```

Main output:

- Per-chromosome compressed VCF files: `*.vcf.gz`
- VCF index files: `*.vcf.gz.csi`

### 6. VCF filtering

Script:

```bash
scripts/6_filter.sh
```

Filter variants by quality and depth, then keep only biallelic SNPs.

```bash
sbatch scripts/6_filter.sh
```

Main output:

- Filtered VCF file: `filtered.vcf.gz`
- Biallelic SNP VCF file: `dog_snps.vcf.gz`
- VCF index file

### 7. Convert VCF to PLINK format

Script:

```bash
scripts/7_plink.sh
```

Convert the filtered VCF file into PLINK binary format for GWAS analysis.

```bash
sbatch scripts/7_plink.sh
```

Main output:

- `dog_raw.bed`
- `dog_raw.bim`
- `dog_raw.fam`

### 8. Genotype quality control

Script:

```bash
scripts/9_qc.sh
```

Perform genotype-level and sample-level quality control using PLINK.

```bash
sbatch scripts/9_qc.sh
```

Main output:

- QC-filtered PLINK files: `dog_qc.bed`, `dog_qc.bim`, and `dog_qc.fam`

### 9. GWAS without PCA covariates

Script:

```bash
scripts/10_gwas.sh
```

Run a linear regression GWAS using the QC-filtered genotype data and the average height phenotype file.

```bash
sbatch scripts/10_gwas.sh
```

Main output:

- GWAS association results: `gwas_ave_height.assoc.linear`

### 10. LD pruning

Script:

```bash
scripts/11_pruning.sh
```

Perform linkage disequilibrium pruning to select relatively independent SNPs for PCA.

```bash
sbatch scripts/11_pruning.sh
```

Main output:

- Pruned SNP list: `prune.prune.in`
- Excluded SNP list: `prune.prune.out`

### 11. Principal component analysis

Script:

```bash
scripts/12_pca.sh
```

Calculate the first 20 principal components using the LD-pruned SNP set.

```bash
sbatch scripts/12_pca.sh
```

Main output:

- PCA eigenvector file: `pca20.eigenvec`
- PCA eigenvalue file: `pca20.eigenval`

### 12. GWAS with PCA covariates

Script:

```bash
scripts/13_gwas_again.sh
```

Run the final GWAS model with the first 20 principal components included as covariates to control for population structure.

```bash
sbatch scripts/13_gwas_again.sh
```

Main output:

- PCA-adjusted GWAS association results: `gwas_ave_height_pca3.assoc.linear`

## Notes

- The scripts use absolute paths from the HPC working directory. These paths should be updated if the repository is run in a different environment.
- SLURM array jobs are used for sample-level and chromosome-level parallelisation.
- `set -eo pipefail` is used in most scripts to stop the pipeline when a command fails.

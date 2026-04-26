rm(list = ls())
install.packages("qqman")
library(qqman)

# Read in the GWAS results before PCA correction
gwas <- read.table("../data/gwas_ave_height.assoc.linear", header = TRUE)

# Pick out the columns needed for the Manhattan plot and remove rows with missing values
gwas2 <- na.omit(gwas[, c("CHR", "BP", "P", "SNP")])

# qqman needs the chromosome column to be numeric, so convert the chromosome IDs to numbers
gwas2$CHR <- as.character(gwas2$CHR)
gwas2$CHR <- factor(gwas2$CHR, levels = unique(gwas2$CHR))
gwas2$CHR <- as.numeric(gwas2$CHR)

# Plot the Manhattan plot for the original GWAS results
manhattan(gwas2,
          chr = "CHR",
          bp = "BP",
          snp = "SNP",
          p = "P",
          main = "GWAS Manhattan Plot")




#####
### GWAS after PCA correction

library(qqman)

# Read in the GWAS results after adding PCA covariates
gwas3 <- read.table("../data/gwas_ave_height_pca3.assoc.linear", header = TRUE)

# Keep only the ADD rows, as these are the SNP association results
tmp <- subset(gwas3, TEST == "ADD", select = c(CHR, BP, P, SNP))

# The chromosome names are RefSeq IDs, so recode them as 1, 2, 3, etc. for qqman
tmp$CHR <- match(as.character(tmp$CHR), unique(as.character(tmp$CHR)))

# Make sure the position and p-value columns are numeric
tmp$BP  <- as.numeric(tmp$BP)
tmp$P   <- as.numeric(tmp$P)

# Keep SNP IDs as character values
tmp$SNP <- as.character(tmp$SNP)

# Remove any rows where chromosome, position, or p-value is missing
tmp <- tmp[!is.na(tmp$CHR) & !is.na(tmp$BP) & !is.na(tmp$P), ]

# Remove invalid p-values
tmp <- tmp[tmp$P > 0 & tmp$P <= 1, ]

# Put the SNPs in chromosome and position order before plotting
tmp <- tmp[order(tmp$CHR, tmp$BP), ]

# Plot the Manhattan plot for the PCA-corrected GWAS results
manhattan(tmp,
          chr = "CHR",
          bp = "BP",
          snp = "SNP",
          p = "P",
          main = "GWAS Manhattan Plot after PCA")
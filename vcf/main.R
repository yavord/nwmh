library(vcfR)
library(magrittr)
source("functions.R")

# files
vcfDir <- "../input/"
vcfName <- "sample.vcf"
metaName <- "meta.txt"
vcfFull <- paste(vcfDir, vcfName, sep="")
metaFull <-paste(vcfDir, metaName, sep="")
# metadata to append to header
meta <- read.delim(metaFull, header=F) %>% unlist(use.names=F)
vcf <- read.vcfR(vcfFull)

# add meta tags of new fields to vcf
vcf@meta <- c(vcf@meta, meta)
vcf@meta


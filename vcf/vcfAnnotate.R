library(vcfR)
library(magrittr)

# file
vcfDir <- "../input/"

vcfName <- "sample.vcf"
metaName <- "meta.txt"

vcfFull <- paste(vcfDir, vcfName, sep="")
metaFull <-paste(vcfDir, metaName, sep="")

meta <- read.delim(metaFull, header=F) %>% unlist(use.names=F)
vcf <- read.vcfR(vcfFull)

vcf@meta <- c(vcf@meta, meta)
vcf@meta


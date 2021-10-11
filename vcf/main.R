library(vcfR)
library(magrittr)
source("functions.R")

### this script calls all other functions (functions.R) and annotates the
### results to the input .vcf

# files
inputDir <- "../input/"
vcfName <- "sample.vcf"
metaName <- "meta.txt"
exacName <- "exacAnnotations.txt"
vcfFull <- paste(inputDir, vcfName, sep="")
metaFull <-paste(inputDir, metaName, sep="")
exacFull <- paste(inputDir, exacName, sep="")
# metadata to append to header
meta <- read.delim(metaFull, header=F) %>% unlist(use.names=F)
exac <- read.delim(exacFull, header=F, sep=";")
vcf <- read.vcfR(vcfFull)

# add meta tags of new fields to vcf
vcf@meta <- c(vcf@meta, meta)
vcfFinal <- annotateVcf(vcf, exac)

write.vcf(vcfFinal, file = "../output/vcfFinal")

library(vcfR)
library(magrittr)
source("functions.R")

### this script calls all other functions (functions.R) and annotates the
### results to the input .vcf

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


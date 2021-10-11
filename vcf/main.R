library(vcfR)
library(magrittr)
source("functions.R")

### this script calls all other functions (functions.R) and annotates the
### results to the input .vcf

# files
inputDir <- "../input/"
vcfName <- "sample.vcf"
metaName <- "meta.txt"
vcfFull <- paste(inputDir, vcfName, sep="")
metaFull <-paste(inputDir, metaName, sep="")
# metadata to append to header
meta <- read.delim(metaFull, header=F) %>% unlist(use.names=F)
vcf <- read.vcfR(vcfFull)

# add meta tags of new fields to vcf
vcf@meta <- c(vcf@meta, meta)
vcfFinal <- annotateVcf(vcf)
vcfFinal@fix[1,"INFO"]
vcfFinal@gt[1,]

# write.vcf(vcfFinal, file = "vcfFinal")

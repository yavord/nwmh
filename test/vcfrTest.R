library(vcfR)

# file
vcfDir <- "../input/"
vcfName <- "sample.vcf"
vcfFull <- paste(vcfDir, vcfName, sep="")
vcf <- read.vcfR(vcfFull)

# check meta
# head(vcf)
# queryMETA(vcf, element = 'AD')

# check gt
# vcf@gt[1:3, 1:2]

# quality
# plot(vcf)

# fix info fields
fix <- vcf@fix
# gt <- vcf@gt
# info <- data.frame(fix[,8])
# 
# x <- extract.gt(vcf, element = "DP")
# y <- vcfR2tidy(vcf, format_fields = c("GT", "DP"))


fix <- vcf@fix


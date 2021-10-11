library(vcfR)
library(stringr)

### input .vcf and outputs a .txt of <variant_str> needed for ExAC API calls

# files
vcfDir <- "../input/"
vcfName <- "sample.vcf"
vcfFull <- paste(vcfDir, vcfName, sep="")
# open .vcf
vcf <- read.vcfR(vcfFull)

# create empty vector to store final ExAC variant queries
exacQuery <- vector()

for (i in 1:length(vcf@fix[,1])) {
  row <- vcf@fix[i,]
  chr <- str_split(row["CHROM"], "r")[[1]][2] # extract chromosome number
  alt <- str_split(row["ALT"], ",")[[1]] # extract all possible bp
  
  variantStr <- character(0) # init variant strings to be appended to final query
  
  # create variant string (x) for alternative bases and append to variantStr
  for (i in 1:length(alt)) {
    x <- paste(chr, row["POS"], row["REF"], alt[i], sep = "-")
    if (length(variantStr > 0)) {
      variantStr <- paste(variantStr,x,sep=",")
    } else {
      variantStr <- x
    }
  }
  
  exacQuery <- c(exacQuery, variantStr) # append to final output exacQuery
}

writeLines(exacQuery, "../input/exacQuery.txt")

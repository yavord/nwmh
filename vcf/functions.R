library(stringi)
library(magrittr)

### holds all functions for .vcf annotation

# input reference/alternate and output variation type (INV,SUB,INS,DUP,DEL)
annotateVariationType <- function(ref, alt) {
  # find length difference between each alternative variant and reference
  len <- stri_length(alt) - stri_length(ref)
  # find index of most deleterious variant 
  # prioritizing the lowest index in case of equal values
  maxLen <- which.max(abs(len))
  
  vType <- NA # init variation type output
  
  # characterize variation type
  if (len[maxLen] == 0) {
    if (ref == stri_reverse(alt[maxLen])) {
      vType <- "INV"
    } else {vType <- "SUB"}
  } else if(len != 0) {
    if (len < 0) {
      vType <- "DEL"
    } else if(len > 0) {
      ifelse(alt == paste(ref,ref,sep=""),vType <- "DUP",vType <- "INS")
    }
  }
  vType <- paste("VTYPE=",vType,sep="")
  return(vType)
}

# annotateDepth <- function(x) {}
# 
# annotateExac <- function(x) {}

annotateVcf <- function(vcf) {
  lenVar <- length(vcf@fix[,1]) # number of variants
  
  # loop through each variant
  for (i in 1:lenVar) {
    # annotate variation type
    vtype <- annotateVariationType(vcf@fix[i,"REF"],vcf@fix[i,"ALT"])
    vcf@fix[i,"INFO"] <- paste(vcf@fix[i,"INFO"],vtype,sep=";")
    
    # annotate depth of reference/alternative
  }
  
  return(vcf)
}

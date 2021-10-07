library(stringi)
library(magrittr)

### holds all functions for .vcf annotation

# input reference/alternate and output variation type (INV,SUB,INS,DUP,DEL)
annotateVariationType <- function(ref, alt) {
  # find length difference between each alternative variant and reference
  len <- stri_length(alt) - stri_length(ref)
  maxLen <- which.max(abs(len)) # index of most deleterious variant
  # prioritizes lowest index in case of equal values
  
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
      ifelse(alt == paste(r,r,sep=""),vType <- "DUP",vType <- "INS")
    }
  }
  vType <- paste("VTYPE=",vType,sep="")
  return(vType)
}
x <- vcf@fix[,"INFO"]

# annotateDepth <- function(x) {}
# 
# annotateExac <- function(x) {}

annotateVcf <- function(vcf) {
  fix <- vcf@fix
  
  # annotate variation type to vcf
  for (i in 1:length(vcf@fix[,1])) {
    vtype <- annotateVariationType(fix[i,"REF"],fix[i,"ALT"])
    vcf@fix[i,"INFO"] <- paste(fix[i,"INFO"],vtype,sep=";")
  }
  
  return(vcf)
}

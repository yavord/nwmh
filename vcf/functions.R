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
  vType <- paste("SVTYPE=",vType,sep="")
  return(vType)
}

# input .vcf fix info and gt for single row
# output vector (1) fix info, (2) gt row with reference/alternate allele depth
annotateDepth <- function(fixInfo, gtRow) {
  
  
  return(c(1,2))
}
# 
# annotateExac <- function(x) {}

annotateVcf <- function(vcf) {
  lenVar <- length(vcf@fix[,1]) # number of variants
  
  # loop through each variant
  for (i in 1:lenVar) {
    fixRow <- vcf@fix[i,] # current row
    gtRow <- 
    
    # annotate variation type
    vtype <- annotateVariationType(fixRow["REF"],fixRow["ALT"])
    fixRow["INFO"] <- paste(fixRow["INFO"],vtype,sep=";")
    
    # annotate depth of reference/alternative
    depth <- annotateDepth(fixRow["INFO"], gtRow)
    fixRow["INFO"] <- depth[1]
    gtRow <- depth[2]
    
    # annotate ExAC data
    
    vcf@fix[i,] <- row 
  }
  
  return(vcf)
}

library(stringi)
library(magrittr)

### holds all functions for .vcf annotation

annotateVariationType <- function(ref, alt) {
  len <- stri_length(alt) - stri_length(ref)
  maxLen <- which.max(abs(len)) # index of most deleterious
  # prioritizes lowest index in case of equal values
  
  vType <- NA # init variation type output
  
  if (len[maxLen] == 0) {
    if (ref == stri_reverse(alt[maxLen])) {
      vType <- "inv"
    } else {vType <- "sub"}
  } else if(len != 0) {
    if (len < 0) {
      vType <- "del"
    } else if(len > 0) {
      ifelse(alt == paste(r,r,sep=""),vType <- "dup",vType <- "ins")
    }
  }
  return(vType)
}

# annotateDepth <- function(x) {}
# 
# annotateExac <- function(x) {}
# 
# annotateVcf <- function(x) {}

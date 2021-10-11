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

# input .vcf fix info and gt for single row since .vcf is derived from the .bam
# output vector (1) fix info, (2) gt row: both with reference/alternate allele depth
annotateDepth <- function(fixInfo, gtRow) {
  # Get read depth for alternate and reference alleles for INFO section
  infoList <- stri_split(str=fixInfo,regex=";")[[1]] %>% # split into list
    stri_split_fixed(pattern = '=',n=2)
  DPA <- paste("DPA",infoList[[2]][2],sep="=") # get AO
  DPR <- paste("DPR",infoList[[30]][2],sep="=") # get RO
  fixInfo <- paste(fixInfo,DPA,DPR,sep=";") # append annotations to fixInfo
  
  # Get read depth for alternate and reference alleles for vcf gt
  gtRowSplit <- sapply(gtRow,stri_split,regex=":") # split columns into lists
  aoIndex <- which(gtRowSplit[["FORMAT"]]=="AO") # get list index for AO/RO
  roIndex <- which(gtRowSplit[["FORMAT"]]=="RO")
  gtRow[1] <- paste(gtRow[1],"DPA","DPR",sep=":") # append annotations to gtRow
  gtRow[2] <- paste(
    gtRow[2],gtRowSplit[["SAMPLE"]][aoIndex],gtRowSplit[["SAMPLE"]][roIndex],sep=":"
  )
  
  return(c(fixInfo,gtRow))
}
# 
# annotateExac <- function(x) {}

annotateVcf <- function(vcf) {
  lenVar <- length(vcf@fix[,1]) # number of variants
  
  # loop through each variant
  for (i in 1:lenVar) {
    fixRow <- vcf@fix[i,] # current row
    gtRow <- vcf@gt[i,]
    
    # annotate variation type
    vtype <- annotateVariationType(fixRow["REF"],fixRow["ALT"])
    fixRow["INFO"] <- paste(fixRow["INFO"],vtype,sep=";")
    
    # annotate depth of reference/alternative
    depth <- annotateDepth(fixRow["INFO"], gtRow)
    fixRow["INFO"] <- depth[1]
    gtRow <- depth[2:3]
    
    # annotate ExAC data
    
    
    # add annotations to output
    vcf@fix[i,"INFO"] <- fixRow["INFO"]
    vcf@gt[i,] <- gtRow
  }
  
  return(vcf)
}


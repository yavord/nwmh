library(dplyr)
library(magrittr)
library(stringr)

### This script takes an input directory of COSMIC targeted screen data (csv) 
### and an input BED file and returns an output BED file that contains the 
### regions that overlap between ALL the COSMIC csv files and the input BED

# find all files in dir
pathC <- "~/projects/RProjects/nwmh/input/cosmic/"
files <- list.files(path=pathC, pattern="*.csv", recursive=F, full.names=T)

lapply(files, function(x) {
  csvFull <- read.csv(x, header = TRUE)
  
})

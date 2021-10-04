library(dplyr)
library(magrittr)
library(stringr)
library(rtracklayer)

### This script takes an input directory of COSMIC targeted screen data (csv) 
### and an input BED file and returns an output BED file that contains the 
### regions that overlap between ALL the COSMIC csv files and the input BED

# find all files in dir
csvDir <- "../input/cosmic/"
files <- list.files(path=csvDir, pattern="*.csv", recursive=F, full.names=T)

# this function takes a COSMIC csv and outputs a DF in the BED format
cosmicToBed <- function(cosmicCsv) {
  # filter out all null entries and select only the coordinates
  cosmicCsv <- cosmicCsv %>%
    filter(str_detect(GRCH, '37')) %>%
    select(MUTATION_GENOME_POSITION)
  
  # split MUTATION_GENOME_POSITION into 3 columns (chr,start,end) to convert to BED
  chr <- str_split_fixed(string = cosmicCsv$MUTATION_GENOME_POSITION, pattern = ":", n = 2)
  chr[,1] <- sprintf("chr%s", chr[,1]) # add "chr" to first row
  bp <- str_split_fixed(string = chr[,2], pattern = "-", n = 2)
  
  # final DF/function output
  final <- data.frame(chr[,1], as.numeric(bp[,1]), as.numeric(bp[,2]))
  colnames(final) <- c("chrom", 'chromStart', 'chromEnd')
  
  return(final)
}

# loop through all files in cosmic dir, convert them to a BED format DF, then
# append to list dataList
dataList <- lapply(files, function(x) {
    csvFull <- read.csv(x, header = TRUE)
    bed <- cosmicToBed(csvFull)
    return(bed)
  })

# combine each cosmic BED into one DF
allF <- bind_rows(dataList)

# convert allF to GRanges object
cosmicGr <- makeGRangesFromDataFrame(allF)

# import panel.bed as GRanges object
panel <- import("../input/panel.bed", format = "bed")

# find overlaps between input bed/hotspots and sort it
hotspotOverlap <- subsetByOverlaps(cosmicGr,panel) %>% sort()
# filter out any sequences with a width of 0
hotspotOverlap <- hotspotOverlap[width(hotspotOverlap) != 0]

# write to BED file in the inputs
write.table(
  hotspotOverlap, "../input/hotspot.bed", 
  col.names = F, row.names = F, quote = F, sep = "\t"
  )


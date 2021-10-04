library(Rsamtools)

### This script indexes and/or sorts an input BAM file

# bam paths
inputPath <- "../input/"
inputBam <- "sample.bam"
bamFull <- paste(inputPath, inputBam, sep="")

# path after sorting
# inputSort <- "sampleSort"
# bamSortFull <- paste(inputPath, inputSort, sep="")

# create BamFile object
bamFile <- BamFile(bamFull)

# sort
# sortBam(bamFile, bamSortFull)
# bamSortFull <- paste(bamSortFull,".bam",sep="") # update path to sorted file
# bamFile <- BamFile(bamSortFull)

# index BAM file
indexBam(bamFile)




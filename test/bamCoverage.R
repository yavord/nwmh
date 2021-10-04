library(Rsamtools)

bamcoverage <- function (bamfile) {
  # read in the bam file
  bam <- scanBam(bamfile)[[1]] # the result comes in nested lists
  # filter reads without match position
  ind <- ! is.na(bam$pos)
  ## remove non-matches, they are not relevant to us
  bam <- lapply(bam, function(x) x[ind])
  ranges <- IRanges(start=bam$pos, width=bam$qwidth, names=make.names(bam$qname, unique=TRUE))
  ## construc: genomic ranges object containing all reads
  ranges <- GRanges(seqnames=Rle(bam$rname), ranges=ranges, strand=Rle(bam$strand), flag=bam$flag, readid=bam$rname )
  ## returns a coverage for each reference sequence (aka. chromosome) in the bam file
  return (mean(coverage(ranges)))      
}

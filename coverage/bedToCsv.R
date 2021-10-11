library(rtracklayer)
library(magrittr)
library(dplyr)

outputDir <- "../output/"
hotspotBedDir <- paste(outputDir, "hotspotBed/hotspotBed.regions.bed", sep="")
panelBedDir <- paste(outputDir, "panelBed/panelBed.regions.bed", sep="")

hotspot <- import(hotspotBedDir, format="bed") %>% 
  as("data.frame") %>% select(1:5,7)
colnames(hotspot)[6] <- "coverage"
panel <- import(panelBedDir, format="bed") %>%
  as("data.frame")
colnames(panel)[7] <- "coverage"

write.csv(hotspot,paste(outputDir,"hotspot.csv",sep=""),row.names=F)
write.csv(panel,paste(outputDir,"panel.csv",sep=""),row.names=F)

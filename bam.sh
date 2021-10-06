#!/bin/bash
# script for component 1 

# Conda env name
ENV="mosdepth"

mkdir -p output/hotspotBed
mkdir -p output/panelBed

cd coverage/
# index BAM
Rscript indexBam.R
# write hotspot.bed
Rscript cosmicParser.R
cd ../

# calculate coverage
eval "$(conda shell.bash hook)"
cd output/panelBed
conda activate $ENV
mosdepth --by ../../input/panel.bed panelBed ../../input/sample.bam
cd ../hotspotBed
conda activate $ENV
mosdepth --by ../../input/hotspot.bed hotspotBed ../../input/sample.bam

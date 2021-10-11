#!/bin/bash
# script for component 2

cd vcf/
Rscript vcfToExacQuery.R
python3 getExacAnnotations.py
Rscript main.R

echo ".vcf script is done"


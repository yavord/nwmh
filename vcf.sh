#!/bin/bash
# script for component 2

# ./mongod.sh start

cd vcf/
Rscript vcfToExacQuery.R

# ./mongod.sh shutdown

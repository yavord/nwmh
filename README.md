# nwmh
Gene level/hotspot coverage and VCF annotations for NWMH

## To run part 1:
1. Download and place input data into the input folder
2. Download targeted screens mutation data .csv's from [COSMIC](https://cancer.sanger.ac.uk/cosmic/download?genome=37) for the genes of interest and place them in the input/cosmic folder
3. In the main directory run `./bam.sh` or look at the script for the right order to run manually. Change the conda directory to the one on your own machine (see the next section).

The following packages and software are needed before running:
* R: `rtracklayer`, `Rsamtools`, `dplyr`, `stringr`, `magrittr`
* A conda environment with `mosdepth` installed. For more information please see their github https://github.com/brentp/mosdepth.


## To run part 2:
1. Download the input data and place them in the input folder.
2. In the main directory run `./vcf.sh` or use the script as a guide to running it manually.

The following packages and software is needed before running:
* R: `vcfR`, `stringr`, `stringi`, `magrittr`
* Python: `requests` 


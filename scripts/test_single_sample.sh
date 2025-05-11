#!/bin/bash

# Define the paths to the input files
SNV_VCF="testdata/COLO829v003T.purple.somatic.vcf.gz"
CNV_SEGMENT="testdata/COLO829v003T.purple.cnv.somatic.tsv"
SV_VCF="testdata/COLO829v003T.purple.sv.vcf.gz"

# Define other parameters
SAMPLE_ID="COLO829v003T"
REF_GENOME="hg38"
OUTPUT_DIR="signatures_singlesample"
N_BOOTSTRAPS=50
CORES=1

# Run the sigscreen.R script with the specified parameters
./sigscreen_single_sample.R \
    --snv="$SNV_VCF" \
    --cnv="$CNV_SEGMENT" \
    --sv="$SV_VCF" \
    --sample="$SAMPLE_ID" \
    --ref="$REF_GENOME" \
    --output_dir="$OUTPUT_DIR" \
    --n_bootstraps="$N_BOOTSTRAPS" \
    --temp_dir="$TEMP_DIR" \
    --cores="$CORES"



# Clean up the temporary directory
rm -rf "$TEMP_DIR"


#!/bin/bash

# Define the paths to the input files
MANIFEST="testdata/manifest.tsv"

# Define other parameters
REF_GENOME="hg38"
OUTPUT_DIR="signatures_manifest"
N_BOOTSTRAPS=50
CORES=1

# Run the sigscreen.R script with the specified parameters
./sigscreen_single_sample.R \
    --manifest="$MANIFEST" \
    --ref="$REF_GENOME" \
    --output_dir="$OUTPUT_DIR" \
    --n_bootstraps="$N_BOOTSTRAPS" \
    --temp_dir="$TEMP_DIR" \
    --cores="$CORES"



# Clean up the temporary directory
rm -rf "$TEMP_DIR"


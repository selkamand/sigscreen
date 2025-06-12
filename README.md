# SigScreen

> [!WARNING]
> SigScreen is in early development and not yet ready for use

**SigScreen** is a nextflow pipeline for end to end mutational signature analysis.

The current implementation leverages [SigVerse](https://github.com/selkamand/sigverse) packages and [sigminer](https://github.com/ShixiangWang/sigminer) for signature fitting.


## Quick Start

Ensure [nextflow](https://www.nextflow.io/docs/latest/install.html) is installed, then run sigscreen:

Create a manifest file (tsv) with 4 columns:

1. **sample** (required) sample identifier

2. **snv** (optional) path to vcf file with SNVs, MNVs, and INDELs.

3. **copynumber** (optional) path to segment file describing copynumber changes. Must be parse-able by sigstart::parse_cnv_to_sigminer().

4. **sv** (optional) path to segment file describing structural variant changes. Must be parse-able by sigstart::parse_purple_sv_vcf_to_sigminer()

At least one of the mutation files must be supplied for each sample.

Run signature analysis for every sample:

```
nextflow run -profile docker selkamand/sigscreen \
    --manifest=/path/to/manifest.tsv \
    --ref=hg38 \
    --n_bootstraps=25 \
    --cores=1
```

You may need to replace `-profile docker` with `-profile singularity` if working in linux environment.

## For Developers

### Building the dockers

Clone then cd into the repo and build the image with docker
```
docker build --tag sigscreen:v0.0.1
```

## Test docker image

From inside the sigscreen directory run:

```
docker run --rm -v ./testdata/:/app/testdata \
    selkamandcci/sigscreen:v0.0.3 ./sigscreen.R \
        --manifest=manifest.tsv
        --ref=hg38 \
        --output_dir=/app/testdata/signatures \
        --n_bootstraps=25 \
        --temp_dir=/app/temp \
        --cores=1
```
```
docker run -it -v ./testdata/:/app/testdata selkamandcci/sigscreen:v0.0.3 sh
```
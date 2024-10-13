# SigScreen

> [!WARNING]
> SigScreen is in early development and not yet ready for use

**SigScreen** is a nextflow pipeline for end to end mutational signature analysis.

The current implementation leverages [SigVerse](https://github.com/selkamand/sigverse) packages and [sigminer](https://github.com/ShixiangWang/sigminer) for signature fitting.


## Quick Start

Ensure [nextflow](https://www.nextflow.io/docs/latest/install.html) is installed, then run sigscreen:

```
nextflow run sigscreen.nf \
    --snv=/path/to/your/<sample>.purple.somatic.vcf.gz \
    --cnv=/path/to/your/<sample>.purple.cnv.somatic.tsv \
    --sv=/path/to/your/<sample>.purple.sv.vcf.gz \
    --sample=<sample> \
    --ref=hg38 \
    --n_bootstraps=25 \
    --cores=1
```

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
    sigscreen:v0.0.1 ./sigscreen.R \
        --snv=/app/testdata/COLO829v003T.purple.somatic.vcf.gz \
        --cnv=/app/testdata/COLO829v003T.purple.cnv.somatic.tsv \
        --sv=/app/testdata/COLO829v003T.purple.sv.vcf.gz \
        --sample=COLO829v003T \
        --ref=hg38 \
        --output_dir=/app/testdata/signatures \
        --n_bootstraps=25 \
        --temp_dir=/app/temp \
        --cores=1
```

```
docker run -it -v ./testdata/:/app/testdata sigscreen:v0.0.1 sh
```
#!/usr/bin/env Rscript

# Load necessary libraries
library(optparse)

# Define the list of options
option_list <- list(
  make_option(c("-s", "--snv"),
    type = "character", default = NULL,
    help = "Path to the VCF file describing SNVs and INDELs.", metavar = "vcf_snv"
  ),
  make_option(c("--sv"),
    type = "character", default = NULL,
    help = "Path to the SV VCF file produced by GRIDSS / PURPLE.", metavar = "vcf_sv"
  ),
  make_option(c("-c", "--cnv"),
    type = "character", default = NULL,
    help = "Path to the segment file produced by PURPLE (e.g., TUMOR.purple.cnv.somatic.tsv).", metavar = "segment"
  ),
  make_option(c("-S", "--sample"),
    type = "character", default = NULL,
    help = "String representing the tumor sample identifier (in your VCFs and other files).", metavar = "sampleID"
  ),
  make_option(c("-r", "--ref"),
    type = "character", default = "hg19",
    help = "Reference genome used for mutation calling [default: %default].", metavar = "genome"
  ),
  make_option(c("-f", "--small_variant_filetype"),
    type = "character", default = "vcf",
    help = "vcf or tsv. If tsv, will automatically search header for 'Chromosome', 'Position', 'Ref' and 'Alt' columns (if any missing, will look for common aliases). Position must be 1-based. When TSV, no variant filtering will be done. See sigstart::parse_tsv_to_sigminer_maf() for details [default: %default].", metavar = "filetype"
  ),
  make_option(c("--db_sbs"),
    type = "character", default = NULL,
    help = "Path to signature collection for SBS analysis (csv with columns `signature` `type`  `channel` `fraction`)", metavar = "sig_collection"
  ),
  make_option(c("--db_indel"),
    type = "character", default = NULL,
    help = "Path to signature collection for INDEL analysis (csv with columns `signature` `type`  `channel` `fraction`).", metavar = "sig_collection"
  ),
  make_option(c("--db_dbs"),
    type = "character", default = NULL,
    help = "Path to signature collection for DBS analysis (csv with columns `signature` `type`  `channel` `fraction`).", metavar = "sig_collection"
  ),
  make_option(c("--db_cn"),
    type = "character", default = NULL,
    help = "Path to signature collection for CN analysis (csv with columns `signature` `type`  `channel` `fraction`).", metavar = "sig_collection"
  ),
  make_option(c("--db_sv"),
    type = "character", default = NULL,
    help = "Path to signature collection for SV analysis (csv with columns `signature` `type`  `channel` `fraction`).", metavar = "sig_collection"
  ),
  make_option(c("--ref_tallies"),
    type = "character", default = NULL,
    help = "Path to a parquet file describing catalogues of a reference database.", metavar = "ref_tallies"
  ),
  make_option(c("-o", "--output_dir"),
    type = "character", default = "./signatures",
    help = "The output directory for storing results [default: %default].", metavar = "output_dir"
  ),
  make_option(c("-e", "--exposure_type"),
    type = "character", default = "absolute",
    help = "The type of exposure. One of 'absolute' or 'relative' [default: %default].", metavar = "exposure_type"
  ),
  make_option(c("-n", "--n_bootstraps"),
    type = "integer", default = 100,
    help = "The number of bootstrap iterations for fitting signatures [default: %default].", metavar = "n_bootstraps"
  ),
  make_option(c("-t", "--temp_dir"),
    type = "character", default = tempdir(),
    help = "The temporary directory for storing intermediate files [default: system temp directory].", metavar = "temp_dir"
  ),
  make_option(c("-C", "--cores"),
    type = "integer", default = parallel::detectCores(),
    help = "Number of cores to use [default: %default].", metavar = "cores"
  )
)

# Create the option parser
parser <- OptionParser(option_list = option_list)

# Parse the arguments
arguments <- parse_args(parser)

# Map arguments to variables
path_snvs <- arguments$snv
path_cnvs <- arguments$cnv
path_svs <- arguments$sv
sample_id <- arguments$sample
ref_genome <- arguments$ref
small_variant_filetype <- arguments$small_variant_filetype
db_sbs <- arguments$db_sbs
db_indel <- arguments$db_indel
db_dbs <- arguments$db_dbs
db_cn <- arguments$db_cn
db_sv <- arguments$db_sv
ref_tallies <- arguments$ref_tallies
output_dir <- arguments$output_dir
exposure_type <- arguments$exposure_type
n_bootstraps <- arguments$n_bootstraps
temp_dir <- arguments$temp_dir
cores <- arguments$cores

if (is.null(path_snvs) & is.null(path_cnvs) & is.null(path_svs)) {
  optparse::print_help(parser)
  stop("Must supply one of `--snv`, `--sv`, or `--cnv`")
}

if (is.null(ref_genome)) {
  # optparse::print_help(parser)
  stop("Must indicate reference genome using `--ref` argument (either 'hg19' or 'hg38')")
}

# Run the function with parsed arguments
sigminerUtils::sig_analyse_mutations_single_sample_from_files(
  sample_id = sample_id,
  vcf_snv = path_snvs,
  segment = path_cnvs,
  vcf_sv = path_svs,
  small_variant_filetype = small_variant_filetype,
  include = "pass",
  exclude_sex_chromosomes = TRUE,
  allow_multisample = TRUE,
  db_sbs = db_sbs,
  db_indel = db_indel,
  db_dbs = db_dbs,
  db_cn = db_cn,
  db_sv = db_sv,
  ref_tallies = ref_tallies,
  ref = ref_genome,
  output_dir = output_dir,
  exposure_type = exposure_type,
  n_bootstraps = n_bootstraps,
  temp_dir = temp_dir,
  cores = cores
)

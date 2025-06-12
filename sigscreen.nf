#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 * Define default parameters
 */
params.manifest = null
params.ref = null
params.n_bootstraps = 25
params.cores = 1
params.output_dir = 'signatures'
params.temp_dir = 'temp'
params.small_variant_filetype = 'vcf'

workflow {
  /*
  * Validate required parameters
  */
  if (!params.manifest) {
    error('Please specify the --manifest parameter (path to manifest TSV file with columns sample (sample identifier),snv (path to snv VCF),cnv (path to segment file),sv (path to sv VCF))')
  }
  if (!params.ref) {
    error('Please specify the --ref parameter (reference genome)')
  }

  // 2) Coerce manifest into a path object and check it really exists
  def manifestFile = file(params.manifest)
  if (!manifestFile.exists()) {
    error("Manifest file not found: ${manifestFile}")
  }
  println("✅ Using manifest at: ${manifestFile}")

  /*
   *  Force nextflow to look at each file in manifest so they are automatically copied / symlinked into the working directory
   *  and R script can see them
   */
  def samples_ch = Channel
    .fromPath(params.manifest)
    .splitCsv(header: true, sep: '\t')
    .view { row -> println("DEBUG: got row => ${row}") }
    .map { row ->
      tuple(
        row.sample,
        file(row.snv),
        file(row.copynumber),
        file(row.sv),
      )
    }

  run_sigscreen(samples_ch)
}


/*
 * Main process to run sigscreen
 */
process run_sigscreen {
  input:
  tuple val(sample), file(snv), file(cnv), file(sv)

  output:
  path "${params.output_dir}"

  script:
  """
    # Create temporary directory
    mkdir -p ${params.temp_dir}

    #debug
    pwd

    ls

    # Run sigscreen Single Sample R 
    /app/sigscreen.R \\
    --snv ${snv} \\
    --cnv ${cnv} \\
    --sv ${sv} \\
    --ref=${params.ref} \\
    --small_variant_filetype=${params.small_variant_filetype} \\
    --output_dir=${params.output_dir} \\
    --n_bootstraps=${params.n_bootstraps} \\
    --sample=${sample}  \\
    --temp_dir=${params.temp_dir} \\
    --cores=${params.cores}
    """
}

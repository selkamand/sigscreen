#!/usr/bin/env nextflow

nextflow.enable.dsl=2

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

/*
 * Validate required parameters
 */
if (!params.manifest) error 'Please specify the --manifest parameter (path to manifest TSV file with columns sample (sample identifier),snv (path to snv VCF),cnv (path to segment file),sv (path to sv VCF))'
if (!params.ref) error 'Please specify the --ref parameter (reference genome)'

/*
 * Force nextflow to look at each file in manifest so they are automatically symlinked 
  and R script can see them
 */
workflow {
  Channel
    .fromPath(params.manifest)
    .map { manifestFile ->
      def rows = manifestFile.readLines().drop(1).collect { it.split('\t') }
      rows.collect { sample, snvPath, cnvPath, svPath ->
        tuple(manifestFile, file(snvPath), file(cnvPath), file(svPath))
      }
    }
    .flatten()
    .set { samples_ch }

  run_sigscreen(samples_ch)
}

/*
 * Main process to run sigscreen
 */
process run_sigscreen {

    input:
    path(manifest)

    output:
    path "${params.output_dir}"

    script:
    """
    # Create temporary directory
    mkdir -p ${params.temp_dir}

    #debug
    pwd

    ls

    # Run sigscreen R script
    /app/sigscreen.R \\
        --manifest=${manifest} \\
        --ref=${params.ref} \\
        --small_variant_filetype=${params.small_variant_filetype} \\
        --output_dir=${params.output_dir} \\
        --n_bootstraps=${params.n_bootstraps} \\
        --temp_dir=${params.temp_dir} \\
        --cores=${params.cores}
    """
}

workflow {
    /*
     * Create channel with the input manifest
     */
    input_ch = Channel.of(file(params.manifest))

    /*
     * Invoke the process with the channel
     */
    run_sigscreen(input_ch)
}

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

/*
 * Validate required parameters
 */
if (!params.manifest) error 'Please specify the --manifest parameter (path to manifest TSV file with columns sample (sample identifier),snv (path to snv VCF),cnv (path to segment file),sv (path to sv VCF))'
if (!params.ref) error 'Please specify the --ref parameter (reference genome)'

/*
 * Main process to run sigscreen
 */
process run_sigscreen {
    tag "${params.sample}"

    input:
    tuple path(manifest)

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
        --output_dir=${params.output_dir} \\
        --n_bootstraps=${params.n_bootstraps} \\
        --temp_dir=${params.temp_dir} \\
        --cores=${params.cores}
    """
}

workflow {
    /*
     * Create a tuple channel containing the input files
     */
    input_ch = Channel.of([ params.manifest ]).map { files ->
        files.collect { file(it) }
    }

    /*
     * Invoke the process with the tuple channel
     */
    run_sigscreen(input_ch)
}

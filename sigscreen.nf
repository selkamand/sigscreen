#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
 * Define default parameters
 */
params.snv = null
params.cnv = null
params.sv = null
params.sample = null
params.ref = null
params.n_bootstraps = 25
params.cores = 1
params.output_dir = 'signatures'
params.temp_dir = 'temp'

/*
 * Validate required parameters
 */
if (!params.snv) error 'Please specify the --snv parameter (path to SNV VCF file)'
if (!params.cnv) error 'Please specify the --cnv parameter (path to CNV TSV file)'
if (!params.sv) error 'Please specify the --sv parameter (path to SV VCF file)'
if (!params.sample) error 'Please specify the --sample parameter (sample name)'
if (!params.ref) error 'Please specify the --ref parameter (reference genome)'

/*
 * Main process to run sigscreen
 */
process run_sigscreen {
    tag "${params.sample}"

    input:
    tuple path(snv_file), path(cnv_file), path(sv_file)

    output:
    path "${params.output_dir}"

    script:
    """
    # Create temporary directory
    mkdir -p ${params.temp_dir}

    # Run sigscreen R script
    /app/sigscreen.R \\
        --snv=${snv_file} \\
        --cnv=${cnv_file} \\
        --sv=${sv_file} \\
        --sample=${params.sample} \\
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
    input_ch = Channel.of([ params.snv, params.cnv, params.sv ]).map { files ->
        files.collect { file(it) }
    }

    /*
     * Invoke the process with the tuple channel
     */
    run_sigscreen(input_ch)
}

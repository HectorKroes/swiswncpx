#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Nextflow rnaseq subworkflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Uses already downloaded paired fasta files to perform 
    rna-seq analysis using genome alligner STAR and EdgeR
----------------------------------------------------------------------------------------
*/

process allignData {

  publishDir './data/SRA/treated'
	
  input:
    tuple val(accession), path(paired_files)

  output:
  	path "*.bam"

  script:
  	"""
	STAR --runMode alignReads --genomeDir gencode.v19.annotation.gtf --readFilesIn ${paired_files[0]} ${paired_files[1]}
  	"""
}
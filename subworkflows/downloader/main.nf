#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Nextflow downloader subworkflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Downloads required files in specialized docker 
    containers and saves them to the data folder
----------------------------------------------------------------------------------------
*/

process downloadGDCdata {

  // Downloads and unzips GDC count data
  
  tag "${project}: ${uuid}"
  publishDir './data/GDC/'
  errorStrategy 'retry'

  input:
    tuple val(project), val(uuid)

  output:
    path "${project}/*"
    
  script:
    """
    mkdir ${project}
    gdc-client download ${uuid} -d ${project}
    cd ${project}/${uuid}
    file_name=\$(ls -p | grep -v /)
    gunzip \$file_name
    """
}

process downloadSRAdata {

  // Downloads SRA runs as fastq files
  
  tag "${category}: ${accession}"
  publishDir './data/SRA/'

  input:
    each accession
    val category

  output:
    path "${category}/*.fastq"

  script:
    """
    mkdir ${category}
    cd ${category}
    fastq-dump ${accession} --split-spot --skip-technical
    """
}

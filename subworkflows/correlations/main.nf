#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Nextflow correlations subworkflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Gets FPKM data from different projects and renders
    an html correlations report through RMarkdown 
----------------------------------------------------------------------------------------
*/

process grepGeneFPKM {
    
  // Greps gene data and produces an FPKM file
  
  tag "${project}: ${gene_name}"
  publishDir './data/GDC/treated/'

  input:
    each project
    tuple val(gene_name), val(ensembl_id)
    path files
    path manifest

  output:
    path "${project}_${gene_name}_FPKM.txt"
    
  script:
    """
    grep ${project}, ${manifest} | cut -f 2 -d , > folder_list.txt
    head folder_list.txt
    grep -r ${ensembl_id} \$(cat folder_list.txt) >> ${project}_${gene_name}_FPKM.txt
    """
}

process reportCorrelations {
    
  // Uses FPKM data to produce pdf report through RMD

  publishDir './results/'
    
  input:
    path fpkm_data
    path rmd_file

  output:
    path 'correlations.html'
    path '*.png'

  script:
    """
    Rscript -e "rmarkdown::render('${rmd_file}')"
    """
}
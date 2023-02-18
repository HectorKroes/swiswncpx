#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Main nextflow workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DSL 2 Nextflow workflow to reproduce all bioinformatics analysis in the paper "A 
    lncRNA-SWI/SNF complex crosstalk controls transcriptional activation at specific 
    promoter regions" published by Grossi, E., Raimondi, I., Goñi, E. et al. published
    in 2020 in Nature Communications under the DOI code 10.1038/s41467-020-14623-3.
----------------------------------------------------------------------------------------
*/

include { downloadGDCdata } from './subworkflows/downloader'
include { downloadSRAdata } from './subworkflows/downloader'
include { grepGeneFPKM } from './subworkflows/correlations'
include { reportCorrelations } from './subworkflows/correlations'
include { allignData } from './subworkflows/rnaseq'

workflow {
	
  //Downloading data from GDC TCGA LUSC project
  gdc_manifest = Channel
    .fromPath('./data/GDC/GDC_MANIFEST.txt')
    .splitCsv()
  downloadGDCdata(gdc_manifest)

  //Downloading RNA-seq data provided by the authors
  rna_seq_manifest = file('./data/SRA/RNA_seq_manifest.txt')
  rna_seq_accessions = rna_seq_manifest.readLines().flatten()
  downloadSRAdata(rna_seq_accessions, 'rna_seq_data')

  //Grepping genes FPKM data into formatted files
  genes = Channel.from(
  	['SWINGN', 'ENSG00000260910'], 
  	['PDGFRB', 'ENSG00000113721'], 
  	['COL1A1', 'ENSG00000108821'],
  	['GAS6', 'ENSG00000183087'])
  tcga_projects = Channel.from('LUSC', 'BRCA', 'LUAD', 'PRAD', 'COAD')
  grepGeneFPKM(tcga_projects, genes, downloadGDCdata.out.collect(), file('./data/GDC/GDC_MANIFEST.txt'))

  //Creating FPKM correlations report
  corr_rep = Channel.fromPath('./rscripts/correlations.Rmd')
  reportCorrelations(grepGeneFPKM.out.collect(), corr_rep)

  /*
  //Align RNA-seq data with STAR
  rna_seq_paired = Channel
    .fromFilePairs('./data/SRA/rna_seq_data/SRR**_{1,2}.fastq')
  allignData(rna_seq_paired)
  */
  
}
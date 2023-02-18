FROM ubuntu:22.04

MAINTAINER hfkroes

# Installing necessary dependencies
RUN  apt-get update \
	&& apt-get install -y g++ \
	&& apt-get install -y make \
	&& apt-get install -y wget \
	&& apt-get install -y bzip2 \
	&& apt-get install libz-dev

# Install HTSLib v.1.3.2
RUN wget https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 -O htslib.tar.bz2 \
	&& tar -xjvf htslib.tar.bz2 \
	&& cd htslib-1.3.2 \
	&& make \
	&& make install

ENV PATH=${PATH}:/htslib-1.3.2

# Install STAR v2.7.10b
RUN wget https://github.com/alexdobin/STAR/archive/2.7.10b.tar.gz \
	&& tar -xzf 2.7.10b.tar.gz \
	&& cd STAR-2.7.10b/source \
	&& make STAR

ENV PATH=${PATH}:/STAR-2.7.10b/bin/Linux_x86_64

# Get hg19 genome annotation files from ENCODE (Release 19 - GRCh37.p13)
RUN wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.chr_patch_hapl_scaff.annotation.gtf.gz \
	&& wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/GRCh37.p13.genome.fa.gz \
	&& gunzip gencode.v19.chr_patch_hapl_scaff.annotation.gtf.gz \
	&& gunzip GRCh37.p13.genome.fa.gz

# Make STAR index genome
RUN mkdir genomedir \
	&& STAR --runMode genomeGenerate --genomeDir genomedir --genomeFastaFiles GRCh37.p13.genome.fa --sjdbGTFfile gencode.v19.chr_patch_hapl_scaff.annotation.gtf
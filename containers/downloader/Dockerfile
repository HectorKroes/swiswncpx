FROM ubuntu:22.04

MAINTAINER hfkroes

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip

# Installing SRA Toolkit v3.0.2
RUN mkdir sra-toolkit \
	&& cd sra-toolkit \
	&& wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.2/sratoolkit.3.0.2-ubuntu64.tar.gz \
	&& tar -vxzf sratoolkit.tar.gz -C /sra-toolkit \
	&& rm sratoolkit.tar.gz

# Installing GDC Data Transfer Tool Client v1.6.1
RUN mkdir gdc-client \
	&& cd gdc-client \
	&& wget --output-document gdc-client.zip https://gdc.cancer.gov/files/public/file/gdc-client_v1.6.1_Ubuntu_x64.zip \
	&& unzip gdc-client.zip \
	&& rm gdc-client.zip \
	&& chmod +x /gdc-client/gdc-client

ENV PATH=${PATH}:/sra-toolkit/sratoolkit.3.0.2-ubuntu64/bin
ENV PATH=${PATH}:/gdc-client
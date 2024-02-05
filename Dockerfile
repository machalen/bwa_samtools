###########################################################
# Dockerfile to use BWA and samtools
# Based on Ubuntu
############################################################

#Set the image based on Ubuntu
FROM ubuntu:latest

#File Author/Maintainer
MAINTAINER Machalen, magdalena.arnalsegura@iit.it

#Update the repository sources list and install essential libraries
RUN apt-get update && apt-get install --yes build-essential gcc-multilib apt-utils \
	zlib1g-dev liblzma-dev wget git libbz2-dev libcurl4-openssl-dev
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

#Install required libraries in ubuntu other packages
RUN apt-get update -y && apt-get install -y \
	unzip bzip2 g++ make ncurses-dev default-jdk default-jre libncurses5-dev \
	libbz2-dev perl perl-base

############################################################
#Install BWA
WORKDIR /usr/local
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /usr/local/bwa
RUN make
ENV PATH /usr/local/bwa:$PATH

############################################################
#Set the working directory
WORKDIR /bin
#Download Samtools from GitHub
RUN wget https://github.com/samtools/samtools/releases/download/1.19.2/samtools-1.19.2.tar.bz2
#Unbzip and untar package
RUN tar --bzip2 -xf samtools-1.19.2.tar.bz2
WORKDIR /bin/samtools-1.19.2
RUN ./configure
RUN make
RUN make install
RUN rm /bin/samtools-1.19.2.tar.bz2
#Add samtools to the path variable
ENV PATH $PATH:/bin/samtools-1.19.2

############################################################
#Clean and set workingdir
RUN apt-get clean
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils zlib1g-dev wget
WORKDIR /
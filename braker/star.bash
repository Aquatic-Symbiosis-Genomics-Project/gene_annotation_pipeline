#!/bin/bash

GENOME=$1
FASTQ1=$2
FASTQ2=$3
WD=$4

STAR=/software/npg/current/bin/star

source ~/.bashrc
conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

mkdir -p $WD

# copy fastq
cp $FASTQ1 $WD/fq1.fq.gz
cp $FASTQ2 $WD/fq2.fq.gz
cp $GENOME $WD/genome.fa

cd $WD

# Index the genome fasta - default is 32GB
mkdir genome_index
$STAR --runThreadN 12 --runMode genomeGenerate --genomeDir genome_index --genomeFastaFiles genome.fa

# sorted BAM output takes way more memory, so we will sort it afterwards
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn fq1.fq.gz fq2.fq.gz --outFileNamePrefix out --outSAMtype BAM Unsorted --readFilesCommand zcat

# round two with splice junctions from #1
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn fq1.fq.gz fq2.fq.gz --outFileNamePrefix out2 --outSAMtype BAM Unsorted --readFilesCommand zcat --sjdbFileChrStartEnd *.tab
#!/bin/bash

GENOME=$1
FASTQ1=$2
WD=$4

STAR=/software/npg/current/bin/star

source ~/.bashrc
conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

mkdir -p $WD

# copy fastq
cp $FASTQ1 $WD/fq3.fq.gz
cp $GENOME $WD/genome.fa

cd $WD

# Index the genome fasta - default is 32GB
mkdir genome_index
$STAR --runThreadN 12 --runMode genomeGenerate --genomeDir genome_index --genomeFastaFiles genome.fa

# sorted BAM output takes way more memory, so we will sort it afterwards
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn fq3.fq.gz --outFileNamePrefix out3 --outSAMtype BAM Unsorted --readFilesCommand zcat

# round two with splice junctions from #1
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn fq3.fq.gz --outFileNamePrefix out4 --outSAMtype BAM Unsorted --readFilesCommand zcat --sjdbFileChrStartEnd *.tab
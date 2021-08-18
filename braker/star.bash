#!/usr/bin/bash
# usage: star.bash <genome> <FASTQ file> <OUTFILE> 
# * depends on the fastq file ending in .fastq
# * depends on the genome file ending in .fa
# * will copy the resulting BAM file to the current directory
# BSUB bsub -o o.txt -M32000 -R'select[mem>32000] rusage[mem=32000] span[hosts=1]'  -n 12


GENOME=$1
FASTQ=$2
CWD=`pwd`
OUTFILE=$3
STAR=/software/npg/current/bin/star

# change that if needed or add to the commandline
WD=/tmp

conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

# /software/npg/current/bin/star

cd /tmp
[-d $GENOME ] && rm -rf $GENOME
mkdir $GENOME

# copy fastq and compress it
cp $FASTQ .
pigz -p 12 -9 *.fastq
cp $GENOME .

# Index the genome fasta - default is 32GB
mkdir genome_index
$STAR --runThreadN 12 --runMode genomeGenerate --genomeDir genome_index --genomeFastaFiles *.fa

# sorted BAM output takes way more memory, so we will sort it afterwards
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn *.fastq.gz --outFileNamePrefix out --outSAMtype BAM Unsorted --readFilesCommand zcat

# round two with splice junctions from #1
$STAR --genomeDir genome_index --runThreadN 12 --readFilesIn *.fastq.gz --outFileNamePrefix out2 --outSAMtype BAM Unsorted --readFilesCommand zcat --sjdbFileChrStartEnd *.tab

cp out2Aligned.out.bam $WB/$OUTFILE

rm -rf $GENOME

#!/bin/bash
# from https://github.com/Gaius-Augustus/MakeHub
# usage: bsub -q long -I -M20000 -R'select[mem>20000] rusage[mem=20000] span[hosts=1]' build_hub.bash genome.fa ladybird1 icAdaBipu1 braker_output_dir bam_file

GENOME=$1
SHORT_LABEL=$2
LONG_LABEL=$3
BRAKER_OUTPUT=$4
BAMFILE=$5
MAKEHUB=/lustre/scratch123/tol/teams/grit/mh6/MakeHub/make_hub.py

$MAKEHUB -g $GENOME -L $LONG_LABEL -l $SHORT_LABEL -e mh6@sanger.ac.uk -X $BRAKER_OUTPUT -b $BAMFILE


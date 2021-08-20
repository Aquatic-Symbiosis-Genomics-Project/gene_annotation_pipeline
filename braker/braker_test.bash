#!/usr/bin/bash

SPECIES=$4
WD=$3
BAM=$2
GENOME=$1
CORES=11

source ~/.bashrc
conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

# copy of /software/grit/tools/Augustus/config/*
export AUGUSTUS_CONFIG_PATH=/lustre/scratch123/tol/teams/grit/mh6/braker/augustus-config
export AUGUSTUS_BIN_PATH=/lustre/scratch123/tol/teams/grit/mh6/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/lustre/scratch123/tol/teams/grit/mh6/Augustus/scripts
export GENEMARK_PATH=/lustre/scratch123/tol/teams/grit/mh6/gmes_linux_64
export PERL5LIB=/software/grit/conda/envs/braker/lib/site_perl/5.26.2/
export PATH=/software/jre1.8.0_131/bin:/software/grit/conda/envs/python3/bin/:$PATH
export MAKEHUB_PATH=/software/grit/tools/MakeHub/
export SAMTOOLS_PATH=/software/grit/bin/samtools
export GUSHR_PATH=/software/grit/tools/GUSHR

mkdir -p $WD

cp $GENOME $WD/genome.sm.fa
cp $BAM $WD/rnaseq.bam

cd $WD

/software/grit/conda/envs/braker/bin/perl /lustre/scratch123/tol/teams/grit/mh6/BRAKER/scripts/braker.pl --genome genome.sm.fa --softmasking --bam=rnaseq.bam -species $SPECIES --cores=$CORES --nocleanup --gff3
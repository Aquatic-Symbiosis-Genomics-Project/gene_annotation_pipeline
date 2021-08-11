#!/usr/bin/bash
# usage: braker_test.bash <genome.fasta> <bam file> <species name>
# WARNING: this will run the github master version

# BSUB: bsub -q long -o only_rnaseq.lsf -n 15 -M20000 -R'select[mem>20000] rusage[mem=20000] span[hosts=1]'

SPECIES=$3
BAM=$2
GENOME=$1
CORES=14

source ~/.bashrc
conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

# copy of /software/grit/tools/Augustus/config/*
export AUGUSTUS_CONFIG_PATH=/lustre/scratch123/tol/teams/grit/mh6/braker/augustus-config

export GENEMARK_PATH=/lustre/scratch123/tol/teams/grit/mh6/gmes_linux_64
export PERL5LIB=/software/grit/conda/envs/braker/lib/site_perl/5.26.2/
export PATH=/software/jre1.8.0_131/bin:/software/grit/conda/envs/python3/bin/:$PATH
export MAKEHUB_PATH=/software/grit/tools/MakeHub/

# --UTR=on is currently broken
/software/grit/conda/envs/braker/bin/perl /lustre/scratch123/tol/teams/grit/mh6/BRAKER/scripts/braker.pl --genome $GENOME --softmasking --bam=$BAM -species $SPECIES --cores=$CORES --nocleanup

#!/usr/bin/bash

PROTEINS=$2
SPECIES=$4_prothint
WD=$3
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
export GENEMARK_PATH=/lustre/scratch123/tol/teams/grit/mh6/gmes_linux_64_4
export PERL5LIB=/software/grit/conda/envs/braker/lib/site_perl/5.26.2/
export PATH=/software/jre1.8.0_131/bin:/software/grit/conda/envs/python3/bin/:$PATH
export SAMTOOLS_PATH=/software/grit/bin
export PROTHINT_PATH=/lustre/scratch123/tol/teams/grit/mh6/ProtHint-2.6.0/bin

mkdir -p $WD

cp $GENOME $WD/genome.sm.fa
cd $WD

SPECIESDIR="/lustre/scratch123/tol/teams/grit/mh6/braker/augustus-config/species/$SPECIES"
if [ -d "$SPECIESDIR" ]
   then
     rm -rf $SPECIESDIR
fi

/software/grit/conda/envs/braker/bin/perl /lustre/scratch123/tol/teams/grit/mh6/BRAKER/scripts/braker.pl --genome genome.sm.fa --softmasking -species $SPECIES --cores=$CORES --nocleanup --gff3 --prot_seq=$PROTEINS

touch s3_protein_braker_done

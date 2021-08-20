#!/bin/bash
# bsub -o runrm.log -q basement -M32000 -R'select[mem>32000 && tmp>32G] rusage[mem=32000,tmp=32G] span[hosts=1]' -n 12

INFILE=$1
LIB=$2
DIR=$3

export MODULEPATH=/software/modules/:$MODULEPATH
module load ISG/singularity/

#conda activate singularity env

export SINGULARITY_TMPDIR=/lustre/scratch123/tol/teams/grit/mh6/singularity
export SINGULARITY_CACHEDIR=/lustre/scratch123/tol/teams/grit/mh6/singularity
IMG=/lustre/scratch123/tol/teams/grit/mh6/singularity/tetools.sif

mkdir -p $DIR

cp $INFILE $DIR/infile.fa
cp $LIB $DIR/library.fa

cd $DIR

singularity exec --bind `pwd`:$HOME $IMG RepeatMasker -lib library.fa infile.fa -xsmall -pa 11
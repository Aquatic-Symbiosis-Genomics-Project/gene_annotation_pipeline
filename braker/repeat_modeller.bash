#!/bin/bash
# 32 threads
# 32G memory
# bsub -o runrm.log -q basement -M32000 -R'select[mem>32000 && tmp>32G] rusage[mem=32000,tmp=32G] span[hosts=1]' -n 32

INFILE=$1
SPECIES=$2
DIR=`pwd`

export MODULEPATH=/software/modules/:$MODULEPATH
module load ISG/singularity/

#conda activate singularity env

export SINGULARITY_TMPDIR=/lustre/scratch123/tol/teams/grit/mh6/singularity
export SINGULARITY_CACHEDIR=/lustre/scratch123/tol/teams/grit/mh6/singularity


cd /tmp/

[ -d $INFILE ] && rm -rf $INFILE

mkdir -p $INFILE/out

cd $INFILE

cp $DIR/$INFILE out/
cp /lustre/scratch123/tol/teams/grit/mh6/singularity/tetools.sif .

cd out/

IMG=/tmp/$INFILE/tetools.sif

singularity exec --bind `pwd`:$HOME $IMG BuildDatabase -name $SPECIES $INFILE
singularity exec --bind `pwd`:$HOME $IMG RepeatModeler -database $SPECIES -LTRStruct -pa 32
singularity exec --bind `pwd`:$HOME $IMG RepeatMasker -lib $SPECIES-famliies.fa $INFILE -xsmall -pa 32

cd ..
tar cvf $DIR/$species.tar out/
cd ..
rm -rf $INFILE
cd $DIR
xz -9 -e -T 32 $species.tar

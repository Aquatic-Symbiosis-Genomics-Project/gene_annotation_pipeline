#!/usr/bin/bash

PROTEINS=$6
SPECIES=$5
WD=$4
BAM1=$2
BAM2=$3
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
export MAKEHUB_PATH=/software/grit/tools/MakeHub
export SAMTOOLS_PATH=/software/grit/bin
export GUSHR_PATH=/software/grit/tools/GUSHR
export PROTHINT_PATH=/lustre/scratch123/tol/teams/grit/mh6/ProtHint-2.6.0/bin

mkdir -p $WD

cp $GENOME $WD/genome.sm.fa
cp $BAM1 $WD/rnaseq.bam
cp $BAM2 $WD/rnaseq2.bam
cd $WD

bam1=rnaseq.bam
bam2=rnaseq2.bam

# bit of logic to avoid empty bam files being passed through
export bams=''
if [[ $(stat -c%s $bam1) > 21000  && $(stat -c%s $bam2) > 21000 ]]
	then 
		bams="$bam1,$bam2"
elif [[ $(stat -c%s $bam1) > 21000 ]]
	then
		bams="$bam1"
elif [[ $(stat -c%s $bam2) > 21000 ]]
	then
		bams="$bam2"
fi

SPECIESDIR="/lustre/scratch123/tol/teams/grit/mh6/braker/augustus-config/species/$SPECIES"
if [ -d "$SPECIESDIR" ]
	then
		rm -rf $SPECIESDIR
fi

protops=''
if [ $PROTEINS ]
	then
		protopts="--prot_seq=$PROTEINS --etpmode"
fi

/software/grit/conda/envs/braker/bin/perl /lustre/scratch123/tol/teams/grit/mh6/BRAKER/scripts/braker.pl --genome genome.sm.fa --softmasking --bam=$bams -species $SPECIES --cores=$CORES --nocleanup --gff3 $protopts

# for snakemake
touch s3_done

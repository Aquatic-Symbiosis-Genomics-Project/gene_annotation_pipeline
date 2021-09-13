#!/usr/bin/env bash
GENOME=$1
LABEL=$2

source ~/.bashrc
eval "$(conda shell.bash hook)"

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
export MAKEHUB_PATH=/software/grit/tools/MakeHub
export SAMTOOLS_PATH=/software/grit/bin
export GUSHR_PATH=/software/grit/tools/GUSHR

if [ -d s4_makehub ]
	then
		rm -rf s4_makehub
fi

mkdir s4_makehub
cd s4_makehub

/lustre/scratch123/tol/teams/grit/mh6/MakeHub/make_hub.py -g $GENOME -L $LABEL -l $LABEL -e test@email.ac.uk -X ../s3_braker/braker -b ../s2_alignment/out2Aligned.out.bam ../s2b_alignment/out4Aligned.out.bam

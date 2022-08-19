!/bin/bash

source ~/.bashrc
conda activate braker
unset PYTHONPATH
source /software/grit/tools/BRAKER/env.sh

export PERL5LIB=/software/grit/conda/envs/braker/lib/site_perl/5.26.2/
export PATH=/software/jre1.8.0_131/bin:/software/grit/conda/envs/python3/bin/:$PATH
export TSEBRA_PATH=:/lustre/scratch123/tol/teams/grit/mh6/TSEBRA

WD=tsebra
mkdir -p $WD
cd $WD

python $TSEBRA_PATH/bin/tsebra.py -g $1,$2 -c $TSEBRA_PATH/config/default.cfg -e $3,$4 -o combined.gtf
touch tsebra_done

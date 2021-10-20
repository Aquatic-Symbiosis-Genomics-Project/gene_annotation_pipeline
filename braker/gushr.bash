#/bin/bash

# gushr.bash bam1 bam2 genome.fa genes.gtf workDir

WD=$5
BAM1=$2
BAM2=$3
GENOME=$1
GTF=$4
CORES=11

export PATH=/lustre/scratch123/tol/teams/grit/mh6/Augustus/scripts:$PATH
export PATH=/software/jre1.8.0_131/bin:/software/grit/conda/envs/python3/bin/:$PATH

mkdir -p $WD

cp $GENOME $WD/genome.sm.fa
cp $BAM1 $WD/rnaseq.bam
cp $BAM2 $WD/rnaseq2.bam
cp $GTF $WD/augustus.gtf
cd $WD

bam1=rnaseq.bam
bam2=rnaseq2.bam
gtf=augustus.gtf
genome=genome.sm.fa

export bams=''
if [[ $(stat -c%s $bam1) > 30000  && $(stat -c%s $bam2) > 30000 ]]
	then 
		bam="$bam1,$bam2"
elif [[ $(stat -c%s $bam1) > 30000 ]]
	then
		bams="$bam1"
elif [[ $(stat -c%s $bam2) > 30000 ]]
	then
		bams="$bam2"
fi

/software/grit/tools/GUSHR/gushr.py -t $gtf -b $bams -g $genome -o gushr -c $CORES

touch gushr_done

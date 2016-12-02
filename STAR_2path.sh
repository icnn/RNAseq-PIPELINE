#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V

# The reference should be located in the lib/STAR directory i.e. ~/lib/STAR_2.1.4a/Mouse_mm9
sample=$1
ref=$2

# There needs to be a "Data:" folder that include the input fastqs
# The Data folder should include the input fastq and

for i in `cat $sample`
	do nDir=$i
	mkdir $nDir
	pushd $nDir
	ln -s ../Data/$i\_1.fastq .
	ln -s ../Data/$i\_2.fastq .
	qsub /coppolalabshares/amrf/RNAseq-tools/GATK/run_2path_STAR_only.sh $i\_1.fastq $i\_2.fastq $ref
	popd
done

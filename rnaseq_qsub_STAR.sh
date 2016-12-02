#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V


# Thereen should be located in the lib/STAR directory i.e. ~/lib/STAR_2.1.4a/Mouse_mm9
ref=$1
# There needs to be a "Data:" folder that include the input fastqs
# The Data folder should include the input fastq and
for i in $PWD/Data/*_1.fastq; do nDir=`basename $i _1.fastq`; mkdir $nDir; pushd $nDir; ln -s $i .; end2=`echo $i | sed 's/_1.fastq/_2.fastq/g'`; ln -s $end2 .; qsub /coppolalabshares/amrf/RNAseq-tools/qsub_STAR.sh *_1.fastq *_2.fastq $ref; popd; done


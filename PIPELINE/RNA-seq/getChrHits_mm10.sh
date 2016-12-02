#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -l h_data=4G
#
echo BEGIN `date`
bam=$1
chrHits=`basename $bam .bam`_chrHits.txt
echo -e chrom'\t'`dirname $bam | xargs -I{} basename {}` > $chrHits
echo $bam
samtools index $bam
samtools idxstats $bam |head -22|cut -f1,3 | grep -v "_" | awk -F"\t" '{print $1"\t"$2/1000000}' >> $chrHits
echo chromosome count `basename $bam .bam` COMPLETED `date`

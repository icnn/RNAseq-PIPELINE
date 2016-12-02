#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -l h_data=2G
#source /u/local/Modules/default/init/modules.sh
ref=$1
out=$2
echo Begin: `date` 1>&2
echo -e gene'\t'$out > $out.count.txt
samtools view -Sh Aligned.out.sam |/share/apps/anaconda/bin/htseq-count -s reverse -m intersection-nonempty - $ref 2> $out.count.error.log >> $out.count.txt
echo count table for $sample complete `date` 1>&2

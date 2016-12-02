#!/bin/bash
#$ -S /bin/bash
#$ -l h_data=4G
#$ -cwd
#$ -V 
input=$1
ref=$2
out=$3
/coppolalabshares/amrf/RNAseq-tools/bin/kent_package/bedGraphToBigWig $input $ref $out.bw 

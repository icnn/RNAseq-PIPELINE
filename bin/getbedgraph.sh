#!/bin/bash
#$ -S /bin/bash
#$ -l h_data=4G
#$ -cwd

input=$1
ref=$2
out=$3 
genomeCoverageBed -bg -ibam $input -g $ref -split -bg  > ${input}.temp
sed 's/^/chr/' ${input}.temp >$out.bedgraph
rm ${input}.temp

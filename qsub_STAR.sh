#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe mpi 16
#$ -l h_data=3G

#$ -V		

# include full path to input
end1=$1
end2=$2
ref=$3

echo BEGIN STAR alignment `pwd` `date`
#/u/home/eeskin/lnavarro/lib/STAR/STAR_2.3.0e.Linux_x86_64/STAR --genomeDir $ref --readFilesIn $end1 $end2 --outReadsUnmapped Fastx --runThreadN 8
/share/apps/STAR_2.4.0j/bin/Linux_x86_64_static/STAR --genomeDir $ref --readFilesIn $end1 $end2 --runThreadN 16 
echo COMPLETE STAR `pwd` `date`



#!/bin/bash
#$ -S /bin/bash
#$ -V
#$ -l h_data=8G
#$ -cwd

sam=$1
# get random 1M reads from Aligned.out.sam
python /coppolalabshares/amrf/RNAseq-tools/getRandomSamAllHits.py Aligned.out.sam 1000000

# convert sam to bam
samtools view -Sb sample_any_1000000_Aligned.out.sam > temp.bam
samtools sort temp.bam sorted
rm temp.bam



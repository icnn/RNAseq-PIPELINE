#!/bin/bash
#$ -V
#$ -cwd
#S /bin/bash
#
samtools view -Sb Aligned.out.sam>temp.bam
samtools sort temp.bam sorted
rm temp.bam
#end_script

#!/bin/bash
#$ -S /bin/bash
#$ -V
#$ -cwd
#
#
echo BEGIN getGeneRegionCounts: `date`
refDir=$2
# THIS VERSION ASSUMES SUBSAMPLE OF 1M UNIQUE SAM ALIGNEMNTS
bam=$1 # include full path
outName=`dirname $bam | xargs -I{} basename {}`
#
# Below are references exracted from UCSC based on reflat annotation      
#
lincRNA=$refDir/lincRNA.bed
miRNA=$refDir/miRNA.bed
pseudogene=$refDir/pseudogene.bed
snoRNA=$refDir/snoRNA.bed
#ncRNA=$refDir/misc_RNA.bed # ONLY FOR RAT
rRNA=$refDir/rRNA.bed
snRNA=$refDir/snRNA.bed
mRNA=$refDir/mRNA.bed
#
# get counts to gene regions
#
linc=`intersectBed -u -bed -abam $bam -b $lincRNA | wc -l | awk '{print $1/1000000}'`
#
mir=`intersectBed -u -bed -abam $bam -b $miRNA | wc -l | awk '{print $1/1000000}'`
#
pseud=`intersectBed -u -bed -abam $bam -b $pseudogene | wc -l | awk '{print $1/1000000}'`
#
nc=`intersectBed -u -bed -abam $bam -b $snoRNA | wc -l | awk '{print $1/1000000}'`
#
ribo=`intersectBed -u -bed -abam $bam -b $rRNA | wc -l | awk '{print $1/1000000}'`
#
sno=`intersectBed -u -bed -abam $bam -b $snRNA | wc -l | awk '{print $1/1000000}'`
#
coding=`intersectBed -u -bed -abam $bam -b $mRNA | wc -l | awk '{print $1/1000000}'`
echo -e region'\n'pseudogene'\n'snoRNA'\n'lincRNA'\n'miRNA'\n'snRNA'\n'rRNA'\n'protein_coding > $outName.colname
echo -e $outName'\n'$pseud'\n'$nc'\n'$linc'\n'$mir'\n'$sno'\n'$ribo'\n'$coding > $outName.countDat
#
paste $outName.colname $outName.countDat > ensembl.coverageSum
#
cat ensembl.coverageSum
#
rm $outName.colname $outName.countDat
echo COMPLETE getGeneRegionCounts: `date`

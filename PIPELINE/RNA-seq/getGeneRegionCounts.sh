#!/bin/bash
#$ -S /bin/bash
#$ -V
#$ -cwd
#
#
echo BEGIN getGeneRegionCounts: `date`
refDir=$2
# THIS VERSION ASSUMES SUBSAMPLE OF 1M UNIQUE SAM ALIGNEMNTS
bam=$1 # include full patth
outName=`dirname $bam | xargs -I{} basename {}`
#
# Below are references exracted from UCSC based on reflat annotation      
#
exon=$refDir/exon.merged.bed
gene=$refDir/gene.merged.bed
utr5=$refDir/utr5.merged.bed
utr3=$refDir/utr3.merged.bed
intron=$refDir/intron.strict.bed
#
# get counts to intergeninc regions (complement of annotated isoforms) 
#
intergenic=`intersectBed -v -bed -abam $bam -b $gene | wc -l | awk '{print $1/1000000}'`
#
# get counts to gene regions
#
genic=`intersectBed -u -bed -abam $bam -b $gene | wc -l | awk '{print $1/1000000}'`
#
fiveUTR=`intersectBed -u -bed -abam $bam -b $utr5 | wc -l | awk '{print $1/1000000}'` 
#
threeUTR=`intersectBed -u -bed -abam $bam -b $utr3 | wc -l | awk '{print $1/1000000}'` 
#
exonic=`intersectBed -u -bed -abam $bam -b $exon | wc -l | awk '{print $1/1000000}'` 
#
intronic=`intersectBed -u -bed -abam $bam -b $intron | wc -l | awk '{print $1/1000000}'` 
#
echo -e region'\n'exonic'\n'utr5'\n'utr3'\n'intronic'\n'genic'\n'intergenic > $outName.colname
echo -e $outName'\n'$exonic'\n'$fiveUTR'\n'$threeUTR'\n'$intronic'\n'$genic'\n'$intergenic > $outName.countDat
#
paste $outName.colname $outName.countDat > refFlat.coverageSum
#
cat refFlat.coverageSum
#
rm $outName.colname $outName.countDat
echo COMPLETE getGeneRegionCounts: `date`

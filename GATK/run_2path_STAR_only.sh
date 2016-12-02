#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe mpi 18
#$ -l h_data=2500m
#$ -V

# include full path to input
end1=$1
end2=$2
ref=$3
dref=`dirname $ref`
stardir=/share/apps/STAR_2.4.0j/bin/Linux_x86_64_static

mkdir "Firstpath"
cd ./Firstpath
echo BEGIN STAR Firstpass alignment `pwd` `date`
$stardir/STAR --genomeDir $dref --readFilesIn ../$end1 ../$end2 --runThreadN 18
echo COMPLETE STAR Firstpass alignement `pwd` `date`
rm Aligned.out.sam
mv Log.final.out Log.final.out1
mv log.final.out1 ../

cd ../
mkdir "genomeDir"
cd ./genomeDir

echo BEGIN STAR GenomeGenerate `pwd` `date`
$stardir/STAR --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles $ref --sjdbFileChrStartEnd ../Firstpath/SJ.out.tab --sjdbOverhang 99 --runThreadN 18
echo COMPLETE STAR GenomeGenerate `pwd` `date`

cd ../
mkdir "SecondPath"
cd ./SecondPath
echo BEGEN STAR Secondpass alignment `pwd` `date`
$stardir/STAR --genomeDir ../genomeDir --readFilesIn ../$end1 ../$end2 --runThreadN 18 --sjdbFileChrStartEnd ../Firstpath/SJ.out.tab --sjdbOverhang 99
echo COMPLETE STAR 2-pass `pwd` `date`
mv Log.final.out ../
mv Aligned.out.sam ../
rm -r ../Firstpath
rm -r ../SecondPath
rm -r ../genomeDir

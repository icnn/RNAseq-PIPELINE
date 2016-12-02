#!/bin/bash                                                                                                                                  
#$ -S /bin/bash

## Riki Kawaguchi modified on 08/08/14 originally from Neelroop Pariksha
## This script submit a signle bam or sam file (aligned via STAR program) in the current folder 
## Output is written  in QC folder 
## first qrugment is either usually Aligned.out.sam or Aligned.out.bam
## secpmd argument is either mm9 or mm10
## third arugment is whether if you want to keep reordered_reads.sorted.bam default=n

TIMESTAMP=$(date +%m%d%y%H%M%S)
                
## Set locations for .jar files
code=/coppolalabshares/amrf/RNAseq-tools/picard-tools-1.118

## First, find the Aligned.out.sam file
bfile=$1
genome=$2
keep=${3:-"n"}
workingdir=$PWD
bamdir=$workingdir

case "$genome" in
	"mm10") echo "Will use mm10 genome.";
		refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/ENSEMBL.mus_musculus.release-75/Mus_musculus.GRCm38.75.dna.primary_assembly.fa;
		refFlat=/coppolalabshares/amrf/Genome_data/Mus_musculus_mm10/UCSC/mm10/refFlat/mm10Pred.refFlat;;
	"mm9") echo "Will use mm9 genome";
		refgenome=/coppolalabshares/amrf/Genome_data/Mus_musculus_mm9/UCSC/mm9/Sequence/WholeGenomeFasta/genome.fa;
		refFlat=/coppolalabshares/amrf/Genome_data/Mus_musculus_mm9/UCSC/mm9/refFlat/mm9Pred.refFlat;;
	"hg38") echo "Will use hg38 genome";
		refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Human_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa;
		refFlat=/coppolalabshares/amrf/Genome_data/GRCh38/GRCh38_hg38-2.refFlat;;
	"hg19") echo "Will use hg37/Hg19 genome";
		refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Genome_hg19/Homo_sapiens.GRCh37.75.dna.primary_assembly_simple.fa;
		refFlat=/coppolalabshares/amrf/Genome_data/Hg19_GRCh37/UCSC/noChr/UCSC_hg19.refFlat;;
	"hg19_tophat") echo "Will use hg37/Hg19 genome";
                refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Genome_hg19/MTisM/Homo_sapiens.GRCh37.75.dna.primary_assembly_M.fa;
                refFlat=/coppolalabshares/amrf/Genome_data/Hg19_GRCh37/UCSC/UCSC_hg19.refFlat;;
	"rn5_EGFP") echo "Will use rn5 genome";
                refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Rat_rn5/EGFPadded/rn5_plus_EGFP.fa;
                refFlat=/coppolalabshares/amrf/Genome_data/Rat_Rn5/withEGFP/Rn5_EGFP.refFlat;;
	"rn5") echo "Will use rn5 genome";
                refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Rat_rn5/rn5.fa;
                refFlat=/coppolalabshares/amrf/Genome_data/Rat_Rn5/Rn5.refFlat;;
	"rn6") echo "Will use rn6 genome";
		refgenome=/coppolalabshares/amrf/Genome_data/STAR_genome/Rat_rn6/rn6.fa;
		refFlat=/coppolalabshares/amrf/Genome_data/Rat_Rn6/Rn6.refFlat;;
	*) echo "The genome specified is not supported";;
esac

bfile1=$(basename $bfile)
bfile=${bfile}
echo Current directory is $workingdir
echo Using $bfile as input
if [ -d QC ]; then
	ls ${bamdir}/QC
	if [ `ls ${workingdir}/QC/*log|wc -l` -gt 0 ];then
		echo "Removing old error and out file...."
		rm ${workingdir}/QC/error*
		rm ${workingdir}/QC/out*
  	fi
	if [ -f ${workingdir}/QC/alignment_stats.txt ] && [ -f ${workingdir}/QC/rnaseq_stats.txt ] && [ -f ${workingdir}/QC/gcbias_stats.txt ] && [ -f ${workingdir}/QC/gcbias_summary.txt ] && [ -f ${workingdir}/QC/duplication_stats.txt ] ;then
		echo "Results file already exist. Do you want to erase? [y/n]"
		read answer
		if [ $answer == "y" ];then 
			ls ${workingdir}/QC
			rm ${workingdir}/QC/alignment_stats.txt
			rm ${workingdir}/QC/rnaseq_stats.txt
			rm ${workingdir}/QC/gcbias_stats.txt
			rm ${workingdir}/QC/gcbias_summary.txt
			rm ${workingdir}/QC/duplication_stats.txt
			rm ${workingdir}/QC/duplication_stats.txt
			rm ${workingdir}/QC/insertSizeHist.txt
			echo "removing result files....."
			ls ${workingdir}/QC
		else
			exit
		fi
	fi

	if [ -e ${workingdir}/QC/reordered_reads.sorted.bam ] ;then
		echo "reordered_reads.sorted.bam already exists."
		echo "Do you want to use this file? [y/n]"
		read answer
		case "$answer" in
			"n") rm ${workingdir}/QC/reordered_reads.sorted.bam
		esac
	fi
else 
	echo "Creating QC directory..."
	mkdir ${workingdir}/QC
fi

echo $PATH
echo $bfile 
echo $bamdir 
echo $workingdir 
echo $refgenome 
echo $refFlat 
echo $keep

qsub -cwd -V -pe mpi 18 -l h_data=2500m, -o ${workingdir}/QC/out_${TIMESTAMP}.log -e ${workingdir}/QC/error_${TIMESTAMP}.log ${code}/../RunPicardScripts_test.sh ${PATH} ${bfile} ${bamdir} ${workingdir} ${refgenome} ${refFlat} ${keep}

exit

#!/bin/bash 
#$ -S /bin/bash 
## Riki Kawaguchi modified on 080814 originally from Neelroop Parikshak
## This script is to be submitted using qsub_picard_scripts.sh 

PATH=${1}
bfile=${2}
bamdir=${3}
workingdir=${4}
refgenome=${5}
refFlat=${6}
keep=${7}

## Set locations for .jar files, also tihs refFlat file corresponds to gencode v18
pic=/coppolalabshares/amrf/RNAseq-tools/picard-tools-1.118
mkdir tmp

if [ ! -f ${workingdir}/QC/rnaseq_stats.txt ] || [ ! -f ${workingdir}/QC/gcbias_summary.txt ] || [ ! -f ${workingdir}/QC/reordered_duplication_marked_reads_sorted.bai ]; then ## Execute scripts if either QC output file is not present
    echo "Running QC stats scripts from PicardTools..."
    if [ ! -f ${workingdir}/QC/reordered_reads.bam  ]; then
	java -Djava.io.tmpdir=tmp1 -Xmx20g -jar ${pic}/ReorderSam.jar INPUT=${bamdir}/${bfile} OUTPUT=${workingdir}/QC/reordered_reads.bam REFERENCE=${refgenome} ALLOW_CONTIG_LENGTH_DISCORDANCE=true  ## Reorder the .bam file according to the reference at hand
    else 
       echo "reordered_reads.bam already exists."
    fi
    if [ ! -f ${workingdir}/QC/reordered_reads.sorted.bam ]; then    
    java -Djava.io.tmpdir=tmp1 -Xmx28g -jar ${pic}/SortSam.jar INPUT=${workingdir}/QC/reordered_reads.bam OUTPUT=${workingdir}/QC/reordered_reads.sorted.bam SO=coordinate TMP_DIR=`pwd`/tmp
    rm ${workingdir}/QC/reordered_reads.bam 
    echo "reorder sorted bam file using SortSam.jar completed."
    else
	echo "reordered_reads.sorted.bam file already there"
    fi
    
    if [ ! -f ${workingdir}/QC/alignment_stats.txt ]; then
	java -Djava.io.tmpdir=tmp1 -Xmx40g -jar ${pic}/CollectAlignmentSummaryMetrics.jar REFERENCE_SEQUENCE=${refgenome} INPUT=${workingdir}/QC/reordered_reads.sorted.bam OUTPUT=${workingdir}/QC/alignment_stats.txt ASSUME_SORTED=true ADAPTER_SEQUENCE=null ## Collect alignment metrics if the file is not present
    else
	echo ".bam file already analyzed for alignment metrics"
    fi

    if [ ! -f ${workingdir}/QC/rnaseq_stats.txt ]; then
	java -Djava.io.tmpdir=tmp1 -Xmx40g -jar ${pic}/CollectRnaSeqMetrics.jar REFERENCE_SEQUENCE=${refgenome} INPUT=${workingdir}/QC/reordered_reads.sorted.bam OUTPUT=${workingdir}/QC/rnaseq_stats.txt STRAND_SPECIFICITY=NONE REF_FLAT=${refFlat} ASSUME_SORTED=true ## Collect sequencing metrics if the file is not present
    else
	echo ".bam file already analyzed for RNA seq metrics"
    fi

    if [ ! -f ${workingdir}/QC/gcbias_summary.txt ]; then
	java -Djava.io.tmpdir=tmp1 -Xmx40g -jar ${pic}/CollectGcBiasMetrics.jar REFERENCE_SEQUENCE=${refgenome} INPUT=${workingdir}/QC/reordered_reads.sorted.bam OUTPUT=${workingdir}/QC/gcbias_stats.txt ASSUME_SORTED=true CHART_OUTPUT=${workingdir}/QC/gcbias_chart.pdf SUMMARY_OUTPUT=${workingdir}/QC/gcbias_summary.txt ## Collect gc bias metrics if the file is not present    
    else
	echo ".bam file already analyzed for GC bias"
    fi
    
    if [ ! -f ${workingdir}/QC/insertSizeHist.txt ]; then
	java -Djava.io.tmpdir=tmp1 -Xmx40g -jar ${pic}/CollectInsertSizeMetrics.jar HISTOGRAM_FILE=${workingdir}/QC/insertSizeHist.pdf INPUT=${workingdir}/QC/reordered_reads.sorted.bam OUTPUT=${workingdir}/QC/insertSizeHist.txt REFERENCE_SEQUENCE=${refgenome} ASSUME_SORTED=true
    else 
	echo ".bam file already analyzed insert size"
    fi

    if [ ! -f ${workingdir}/QC/duplication_stats.txt ]; then
	mkdir tmp1
	java -Djava.io.tmpdir=tmp1 -Xmx16g -jar ${pic}/MarkDuplicates.jar INPUT=${workingdir}/QC/reordered_reads.sorted.bam METRICS_FILE=${workingdir}/QC/duplication_stats.txt ASSUME_SORTED=true OUTPUT=${workingdir}/QC/reordered_duplication_marked_reads.bam REMOVE_DUPLICATES=TRUE TMP_DIR=`pwd`/tmp1 ## Collect read duplication metrics if the file is not present, output the marked duplicates file without the duplicates present
#	${jav}/java -Xmx2g -jar ${pic}/SortSam.jar INPUT=${workingdir}/QC/reordered_duplication_marked_reads.bam OUTPUT=${workingdir}/QC/reordered_duplication_marked_reads_sorted.bam SORT_ORDER=coordinate ## Sort the de-duplicated file
	java -Djava.io.tmpdir=tmp1 -Xmx40g -jar ${pic}/BuildBamIndex.jar INPUT=${workingdir}/QC/reordered_duplication_marked_reads_sorted.bam ## Index the de-duplicated file
	## Clean up the extra files
	rm ${workingdir}/QC/reordered_duplication_marked_reads.bam
    else
	echo ".bam file already analyzed for duplicates and processed for deduplication"
    fi
    
    if [ -f ${workingdir}/QC/rnaseq_stats.txt ] && [ -f ${workingdir}/QC/gcbias_summary.txt ] && [ -f ${workingdir}/QC/gcbias_stats.txt ] && [ -f ${workingdir}/QC/alignment_stats.txt ] && [ -f ${workingdir}/QC/duplication_stats.txt ] && [ $keep=="n" ]; then
	rm ${workingdir}/QC/reordered_reads.bam
	rm ${workingdir}/QC/reordered_reads.sorted.bam
	echo "cleaning up the extra bam files"
    fi
else
    echo "RNA seq QC metric files already present"
fi

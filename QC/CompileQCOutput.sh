#!/bin/bash                                                                                                                                  

## Set locations for .jar files
code=/u/home/eeskin2/rkawaguc/RNAseqTools/QC

## First, find the .bam file
workingdir=$PWD
bamdir=${workingdir}
bamlist=$(find $PWD -maxdepth 2 -name Aligned.out.?am)
mkdir Summary

echo $workingdir
echo $bamdir
echo $bamlist

## Start the RNA-seq summary file
echo "FileName PF_BASES PF_ALIGNED_BASES RIBOSOMAL_BASES CODING_BASES UTR_BASES INTRONIC_BASES INTERGENIC_BASES IGNORED_READS CORRECT_STRAND_READS INCORRECT_STRAND_READS PCT_RIBOSOMAL_BASES PCT_CODING_BASES PCT_UTR_BASES PCT_INTRONIC_BASES PCT_INTERGENIC_BASES PCT_MRNA_BASES PCT_USABLE_BASES PCT_CORRECT_STRAND_READS MEDIAN_CV_COVERAGE MEDIAN_5PRIME_BIAS MEDIAN_3PRIME_BIAS MEDIAN_5PRIME_TO_3PRIME_BIAS SAMPLE LIBRARY READ_GROUP" > ${workingdir}/Summary/RNAseqQC.txt
echo "GC WINDOWS READ_STARTS MEAN_BASE_QUALITY NORMALIZED_COVERAGE ERROR_BAR_WIDTH" > ${workingdir}/Summary/RNAseqGC.txt
echo "WINDOW_SIZE TOTAL_CLUSTERS ALIGNED_READS AT_DROPOUT GC_DROPOUT" > ${workingdir}/Summary/GCsummary.txt

echo "Sample CATEGORY TOTAL_READS PF_READS PCT_PF_READS PF_NOISE_READS PF_READS_ALIGNED PCT_PF_READS_ALIGNED PF_ALIGNED_BASES PF_HQ_ALIGNED_READS PF_HQ_ALIGNED_BASES PF_HQ_ALIGNED_Q20_BASES PF_HQ_MEDIAN_MISMATCHES PF_MISMATCH_RATE PF_HQ_ERROR_RATE PF_INDEL_RATE MEAN_READ_LENGTH READS_ALIGNED_IN_PAIRS PCT_READS_ALIGNED_IN_PAIRS BAD_CYCLES STRAND_BALANCE PCT_CHIMERAS PCT_ADAPTER SAMPLE LIBRARY READ_GROUP" > ${workingdir}/Summary/RNAseqAlign.txt
echo "SAMPLE LIBRARY TYPE UNPAIRED_READS_EXAMINED READ_PAIRS_EXAMINED UNMAPPED_READS UNPAIRED_READ_DUPLICATES READ_PAIR_DUPLICATES READ_PAIR_OPTICAL_DUPLICATES PERCENT_DUPLICATION ESTIMATED_LIBRARY_SIZE" > ${workingdir}/Summary/RNAseqDuplication.txt
echo "Sample MEDIAN_INSERT_SIZE MEDIAN_ABSOLUTE_DEVIATION MIN_INSERT_SIZE MAX_INSERT_SIZE MEAN_INSERT_SIZE STANDARD_DEVIATION READ_PAIRS PAIR_ORIENTATION WIDTH_OF_10_PERCENT WIDTH_OF_20_PERCENT WIDTH_OF_30_PERCENT WIDTH_OF_40_PERCENT WIDTH_OF_50_PERCENT WIDTH_OF_60_PERCENT WIDTH_OF_70_PERCENT WIDTH_OF_80_PERCENT WIDTH_OF_90_PERCENT WIDTH_OF_99_PERCENT SAMPLE LIBRARY READ_GROUP" > ${workingdir}/Summary/InsertSizeSummary.txt


for bfile in ${bamlist}
do
    echo $bfile
    bfile1=$(dirname $bfile)
    bfile=$(echo $bfile1|rev|awk -F"/" '{print $1}'|rev) 
    echo $bfile
    
    if [ -f ${workingdir}/${bfile}/QC/gcbias_stats.txt ]
    then
	echo "Getting rnaseq stats"
	var=`sed -n 8p ${workingdir}/${bfile}/QC/rnaseq_stats.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/RNAseqQC.txt
	var=`sed -n 11,112p ${workingdir}/${bfile}/QC/rnaseq_stats.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/TranscriptCoverage.txt

	echo "Getting gcbias stats"
	var=`sed -n 9,1088p ${workingdir}/${bfile}/QC/gcbias_stats.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/RNAseqGC.txt

	echo "Getting gcbias summary"
	var=`sed -n 8p ${workingdir}/${bfile}/QC/gcbias_summary.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/GCsummary.txt

	echo "Getting alignment summary"
	var=`sed -n 8p ${workingdir}/${bfile}/QC/alignment_stats.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/RNAseqAlign.txt

	echo "Getting duplication summary"
	var=`sed -n 8p ${workingdir}/${bfile}/QC/duplication_stats.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/RNAseqDuplication.txt

	echo "Getting insertsize summary"
	var=`sed -n 8p ${workingdir}/${bfile}/QC/insertSizeHist.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/InsertSizeSummary.txt

	echo "Getting insertsize stats"
	var=`sed -n 12,2000p ${workingdir}/${bfile}/QC/insertSizeHist.txt`
	echo ${bfile} ${var} >> ${workingdir}/Summary/InsertSizeStats.txt
    else
	echo "No file for" ${workingdir}/${bfile}/sorted/gcbias_stats.txt
    fi	
done

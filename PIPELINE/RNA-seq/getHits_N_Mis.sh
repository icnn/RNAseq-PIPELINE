#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -l h_data=4G
#
echo BEGIN `date`
bam=$1
hits=`basename $bam .bam`_hits
mis=`basename $bam .bam`_mismatch
samtools view $bam | awk '{for(i=1;i<=NF;i++){if($i~/NH:i:/){Hits[$i]++} if($i~/[n,N]M:i:/){Mis[$i]++}}}END{for(hit in Hits){print hit"\t"Hits[hit]/1000000 > "'$hits'.tmp"}; for(mis in Mis){print mis"\t"Mis[mis]/1000000 > "'$mis'.tmp"}}'
cat $mis.tmp  | sed 's/:i:/\t/g' | sort -k2,2 -n | awk 'NR<=10{print $1$2"\t"$3 > "'$mis'.txt"}; NR>10{gt10+=$3}END{print "NMgt10\t"gt10 >> "'$mis'.txt"}'
cat $hits.tmp | sed 's/:i:/\t/g' | sort -k2,2 -n | awk 'NR<=10{print $1$2"\t"$3 > "'$hits'.txt"}; NR>10{gt10+=$3}END{print "NHgt10\t"gt10 >> "'$hits'.txt"}'
rm $hits.tmp
rm $mis.tmp
echo `basename $bam .bam` COMPLETED `date`

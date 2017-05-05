def getFastqLen(filename):
# THIS FUNCTION GETS LENGTH OF FASTQ FILE 
    fileN = open(filename, "r")
    i = 0
    for line in fileN:
        i += 1
    return i
def randFastq(fastqLength=4000000, n = 10000):
# THIS FUNCTION GETS RANDOMLY SAMPLES 'n' ID POSTIONS FROM A FASTQ FILE OF LENGTH fastqlength
    import random
    id1 = [0]*(fastqLength/4)
    init = 1
    for i in range(fastqLength/4):
        id1[i] = init
        init += 4
    randId1 = random.sample(id1, n)                                      # returns an array of random seq id positions in fastq
    return randId1
def BQ(fastq):
    import linecache
    import random
    fLen = getFastqLen(fastq)
    rId1 = randFastq(fLen)
    rdBases = []
    fqQuals = []
    for i in rId1:
        sread = linecache.getline(fastq, i+1).rstrip('\n')
        qual = linecache.getline(fastq, i+3).rstrip('\n')
        if len(sread) == len(qual):
            rdBases.append(sread)
            fqQuals.append(qual)
    Bases = zip(*rdBases)
    Qualities = zip(*fqQuals)
    base = []
    qual = []
    for j in Bases:
        base.append([i for i in j])
    for j in Qualities:
        qual.append([i for i in j])
    return base, qual
def fastqQcOut(fastq):
# THIS FUNCTION WILL BE GENERAL ANAYLSIS OF SREAD AND QUALITY
# the input should be fastq file of interest 
    import math
    fqStat1 = open(fastq[0:len(fastq)-6] + '_Base_stat.txt','w')
    fqStat2 = open(fastq[0:len(fastq)-6] + '_Qual_stat.txt', 'w')
    Bases = BQ(fastq)[0]
    Qualities = BQ(fastq)[1]
    acgtnProp = []
    q   = []
    for read in Bases:
        acgtnProp.append([read.count('A')/float(len(read)), read.count('C')/float(len(read)), read.count('G')/float(len(read)), read.count('T')/float(len(read)), read.count('N')/float(len(read))])
    for quality in Qualities:
        QualStatDict = dict([(ord(i), quality.count(i)) for i in quality])
        numQual = sorted([ord(i) for i in quality])
        if len(quality)%2 == 1:
            qMedian = numQual[len(numQual)/2]
        else: qMedian = (numQual[len(numQual)/2] + numQual[len(numQual)/2 -1])/2.0
        qMean = sum([key*value for key, value in QualStatDict.items()])/float(len(quality))
        qStd = math.sqrt(sum([(key-qMean)*(key-qMean)*value for key,value in QualStatDict.items()])/float(len(quality)))
        q.append([len(read), qMedian, qMean - qStd, qMean, qMean + qStd])
    for line in acgtnProp:
        for i in line:
            fqStat1.write(str(i) + ' ')
        fqStat1.write('\n')
    for line in q:
        for i in line:
            fqStat2.write(str(i) + ' ')
        fqStat2.write('\n')
    return 

# INPUT: Fastq files of interest in this case that have poor alignment results  
# OUTPUT: 2 txt files for each fastq that summarize Bases per Base Position distribution and Quality statistics
import sys
sys.path.append("/coppolalabshares/amrf/RNAseq-tools")
from fastqQcOut import *
# note that must be in rigth directory for this to work
fastq=sys.argv[1]
fastqQcOut(fastq)

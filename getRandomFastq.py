import sys
def getRandomFastq(fastq, numReads):
    import random
    f=open(fastq,"r")
    g=open(str("rand_"+str(numReads)+"_"+fastq),"w")
    f.seek(-1,2)
    end=f.tell()
    ids={}
    nb=1
    f.seek(nb,0)
    window=end/numReads
    while len(ids) < numReads and nb < end:
        rbt=random.randrange(1,window)
        f.seek(rbt,1)
        line=f.readline()
        nb=f.tell()
        while line[0:2]!="@K":
            line=f.readline()
            nb=f.tell()
        id=line
        read=f.readline()
        id2=f.readline()
        qual=f.readline()
        g.write(id)
        g.write(read)
        g.write(id2)
        g.write(qual)
        ids[id]=1
    f.close()
    g.close()
    return
sys.path.append("/u/home/eeskin2/rkawaguc/PIPELINE/RNA-seq")
from getRandomFastq import *
fastq=sys.argv[1]
numReads=sys.argv[2]
getRandomFastq(fastq,int(numReads))

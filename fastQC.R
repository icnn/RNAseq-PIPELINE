# INPUT:  Read in Base Pair per Base Position Stats and Quality Stats files for fastq files of interest
# OUTPUT: Plots to visualize above statistics for given txt files
Mbase = list.files(pattern = '(_Base_stat.txt)')
Mqual = list.files(pattern = '(_Qual_stat.txt)')
pdf(file = "nucleotide.pdf", width = 16, height = 16)
nPar=ceiling(sqrt(length(Mbase)))
par(mfrow=c(5,4)) # I need to genralize this look at nams ols code
for ( i in Mbase)
{
   BasePrBp = read.table(i)
   name <- gsub("_Base_stat.txt","", i)
   name <- gsub("rand_[0-9]*_","", name)
   plot(range(c(0,dim(BasePrBp)[1])), range(0, 1), type = 'n', main=name, xlab="Base position", ylab = "Nucleotide distribution")
   clr = rainbow(5)
   for (i in 1:dim(BasePrBp)[1])
   {
   rect( i-1, 0,                     i, BasePrBp[i,1],        col=clr[1])
   rect( i-1, BasePrBp[i,1],         i, sum(BasePrBp[i,1:2]), col=clr[2])
   rect( i-1, sum(BasePrBp[i,1:2]),  i, sum(BasePrBp[i,1:3]), col=clr[3])
   rect( i-1, sum(BasePrBp[i,1:3]),  i, sum(BasePrBp[i,1:4]), col=clr[4])
   rect( i-1, sum(BasePrBp[i,1:4]),  i, sum(BasePrBp[i,1:5]), col=clr[5])
   }
}
dev.off()
#
pdf(file = "baseQuality.pdf", width = 12, height = 12)
par(mfrow=c(5, 4)) # I must generalize this like above 
for (i in Mqual)
{
BaseQ <- read.table(i)
name <- gsub("_Qual_stat.txt","", i)
name <- gsub("rand_[0-9]*_","", name)
plot( range(c(1,dim(BaseQ)[1])), range(c(min(BaseQ), max(BaseQ[-1]))), type = 'n', xlab = "Base Position", ylab = "Quality", main=name)
for (i in 1:dim(BaseQ)[1])
{
lines(x = c(i,i), y = c(BaseQ[i,3],BaseQ[i,5]), col = "light blue", lwd = 6)
points(i, BaseQ[i,2], pch = 19, col = "black")
points(i, BaseQ[i,4], pch = 15, col = "red")
}
}
legend("bottomleft", legend=c("Median","Mean"), fill=c("black", "red"))
dev.off()

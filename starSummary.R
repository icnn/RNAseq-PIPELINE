library(gdata)
library(xtable)
#
files <- list.files(pattern="Log.final.out", all.files=T, recursive=T)
#
x <- data.frame(info=read.delim(files[1], header=F)[,1])
for(file in files){
	t<-read.delim(file,header=F)
	names(t)<-c("info", dirname(file))
	x[, dirname(file)] <- t[2]
	}
dim(x)
x<-x[c(5:6,8:20,22:25,27:29),]
x$info<-gsub(",","",x$info)
x$info<-gsub("[|]","",x$info)
x$info<-trim(x$info)
x
hitCount <- x[c(1,3,6,16),]
write.table(x,"starSummary.csv",sep=",",quote=F,col.names=T,row.names=F)
#
tex <- xtable(x)
print(tex,type="latex", file="starSummary.tex")

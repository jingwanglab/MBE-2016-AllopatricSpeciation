#! /usr/bin/Rscript --no-save --no-restore

# Read parameters
#install.packages("RColorBrewer")
library(RColorBrewer)
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10)]



setwd("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/beagle/NGSadmix")


pop=read.table("species.samples.txt",as.is=T)
admix2=t(as.matrix(read.table("tremula_tremuloides.all.k2.qopt")))
admix3=t(as.matrix(read.table("tremula_tremuloides.all.k3.qopt")))
admix4=t(as.matrix(read.table("tremula_tremuloides.all.k4.qopt")))
admix5=t(as.matrix(read.table("tremula_tremuloides.all.k5.qopt")))
admix6=t(as.matrix(read.table("tremula_tremuloides.all.k6.qopt")))


#plot
pdf("tremula_tremuloides.ngsadmix.pdf")
mat=matrix(c(1,2,3,4),4,byrow=TRUE)
layout=layout(mat,heights=c(3,3,3,4.5))

#par(mfrow=c(4,1))

#par(mar=c(4,4,0,2))
par(mar=c(0,5,1,1))
#par(mfrow = c(4,1),oma = c(5,4,0,0) + 0.1,mar = c(0,2,1,1) + 0.1)

barplot(admix2,col=c(colors[2],colors[6]),space=0,border=TRUE,ylab="",mar=c(1,4,1,1)+0.1)
#axis(side=1,at=c(0,24,46),labels=FALSE)
#axis(side=1,at=c(12,35),tick=FALSE,labels=c("P.tremula","P.tremuloides"),cex.axis=1.2)
#mtext("K=2",side=2,line=3)
axis(side=2,las=2,line=2,at=0.5,tick=FALSE,labels="K=2",cex.axis=1.2)

par(mar=c(0,5,1,1))
barplot(admix3,col=c(colors[6],colors[4],colors[2]),space=0,border=TRUE,ylab="",mar=c(1,4,1,1)+0.1)
#axis(side=1,at=c(0,24,46),labels=FALSE)
#axis(side=1,at=c(12,35),tick=FALSE,labels=c("P.tremula","P.tremuloides"),cex.axis=1.2)
#mtext("K=3",side=2,line=3,adj=1)
axis(side=2,las=2,line=2,at=0.5,tick=FALSE,labels="K=3",cex.axis=1.2)

par(mar=c(0,5,1,1))
barplot(admix4,col=c(colors[8],colors[4],colors[6],colors[2]),space=0,border=TRUE,ylab="",mar=c(1,4,1,1)+0.1)
#axis(side=1,at=c(0,24,46),labels=FALSE)
#axis(side=1,at=c(12,35),tick=FALSE,labels=c("P.tremula","P.tremuloides"),cex.axis=1.2)
#mtext("K=4",side=2,line=3,adj=1)
axis(side=2,las=2,line=2,at=0.5,tick=FALSE,labels="K=4",cex.axis=1.2)

par(mar=c(5.5,5,1,1))
barplot(admix5,col=c(colors[8],colors[6],colors[10],colors[4],colors[2]),space=0,border=TRUE,ylab="",mar=c(4,4,1,1)+0.1)
#axis(side=1,at=c(0,24,46),labels=FALSE)
axis(side=1,at=c(0:46),labels=FALSE)
#axis(side=1,at=c(12,35),tick=FALSE,labels=c("P.tremula","P.tremuloides"),cex.axis=1.2)
#axis(side=1,at=c(0.5:45.5),tick=FALSE,labels=pop$V2,cex.axis=0.8)
text(c(0.5:45.5),labels=pop$V2,cex=0.9,par("usr")[3]-0.1,srt=90,adj=1,xpd=TRUE)
#mtext("K=5",side=2,line=3,adj=1)
axis(side=2,las=2,line=2,at=0.5,tick=FALSE,labels="K=5",cex.axis=1.2)

#barplot(admix6,col=c("blue","purple","green","orange","yellow","red"),space=0,border=TRUE,ylab="Admixture")
#axis(side=1,at=c(0,24,46),labels=FALSE)
#axis(side=1,at=c(12,35),tick=FALSE,labels=c("P.tremula","P.tremuloides"))
#mtext("K=6",side=3,line=0.5)

dev.off()






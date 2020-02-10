library(RColorBrewer) 
library(ggplot2)
source("https://bioconductor.org/biocLite.R")
biocLite("qvalue")
library(qvalue)

colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10,11,12)]

setwd("~/Dropbox/PaperII/revise_related_paper/data_analysis/fst_simu/")

summary=read.table("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremula_tremuloides.10kb.summary.txt",header=T)
summary$tremula_ldhat_new=summary$tremula_ldhat/1000
summary$tremuloides_ldhat_new=summary$tremuloides_ldhat/1000

summary$tremula_pi_dxy=summary$tremula_tP.norm/summary$dxy
summary$tremuloides_pi_dxy=summary$tremuloides_tP.norm/summary$dxy
summary$dxy_ratio=summary$tremula_tremuloides_dxy/summary$tremula_trichocarpa_dxy
summary$tremula_ldhat_pi=summary$tremula_ldhat_new/summary$tremula_tP.norm
summary$tremuloides_ldhat_pi=summary$tremuloides_ldhat_new/summary$tremuloides_tP.norm
###simulation data
simu_fst=read.table("tremula.tremuloides.fst",header=F)
simu_tremula_pi=read.table("tremula.msms.total.thetas.gz.pestPG",header=F)
simu_tremuloides_pi=read.table("tremuloides.msms.total.thetas.gz.pestPG",header=F)

###recombination rate for both aspen species
png(filename="~/Dropbox/PaperII/revise_related_paper/data_analysis/both_species.rho.png",width=4.5,height=4.5,units='in',res=600)
par(mar=c(4,5,1,1))
boxplot(summary$tremula_ldhat_new*1000,summary$tremuloides_ldhat_new*1000,names=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),col=c(colors[6],colors[2]),ylab=expression(rho/Kbp))
dev.off()


###first, the cut-off for Fst distributions
###for fst
###1. define the upper and lower limit
n=nrow(simu_fst)
p_value_right=rep("NA",nrow(summary))

for (i in 1:nrow(summary))
{
  if(is.na(summary$fst[i])){next}
  else{
    p_value_right[i]=length(which(simu_fst$V2>summary$fst[i]))/n}
  # if (as.numeric(p_value[i])>0.5) {p_value[i]=1-as.numeric(p_value[i])}
  #if (as.numeric(p_value[i])=="0") {p_value[i]="NA"}
}

summary$fst_p_right=p_value_right
#fst_q=qvalue(as.numeric(summary$fst_p[!is.na(as.numeric(summary$fst_p))]))$qvalues
summary$fst_q_right=qvalue(as.numeric(summary$fst_p_right),na.rm=T)$qvalues
p_right_limit=min(summary$fst[which(summary$fst_q_right<=0.01)])  ###0.6868331  ###674

p_value_left=rep("NA",nrow(summary))

for (i in 1:nrow(summary))
{
  if(is.na(summary$fst[i])){next}
  else{
    p_value_left[i]=length(which(simu_fst$V2<summary$fst[i]))/n}
  # if (as.numeric(p_value[i])>0.5) {p_value[i]=1-as.numeric(p_value[i])}
  #if (as.numeric(p_value[i])=="0") {p_value[i]="NA"}
}

summary$fst_p_left=p_value_left
#fst_q=qvalue(as.numeric(summary$fst_p[!is.na(as.numeric(summary$fst_p))]))$qvalues
summary$fst_q_left=qvalue(as.numeric(summary$fst_p_left),na.rm=T)$qvalues
p_left_limit=max(summary$fst[which(summary$fst_q_left<=0.01)])  ###0.1344396  ##263

###plot the histgram of fst
hist_colors_fst=hist(summary$fst[which(summary$fst!="NA")],freq=F,breaks=40,ylim=c(0,5.5),col=colors[1])
lines(density(simu_fst$V2))
fst_colors=rep(colors[1],length(hist_colors_fst$breaks))
fst_colors[hist_colors_fst$breaks>=0.68]=colors[8]
fst_colors[hist_colors_fst$breaks<0.1344]=colors[4]

png("tremula_tremuloides.fst.png",width=5,height=5,units='in',res=600)
plot(hist_colors_fst,col=fst_colors,freq=F,xlab=expression(F[ST]),main="",xlim=c(0,1),ylim=c(0,5.5))
lines(density(simu_fst$V2),lwd=2,col="grey20")
abline(v=0.68,lty=3,col="red",lwd=1.5)
abline(v=0.14,lty=3,col="red",lwd=1.5)
#abline(v=mean(summary$fst,na.rm=T))
legend(0.7,4.5,legend=c("Data","Model"),fill=c(colors[1],"white"),bty="n")
dev.off()


low_fst=summary[which(summary$fst<=p_left_limit),]
low_fst=summary[which(summary$fst<=0.1344396),]
high_fst=summary[which(summary$fst>=0.6868331),]
#rest=summary[which(summary$fst>p_left_limit&summary$fst<p_right_limit),]
rest=summary[which(summary$fst>0.1344396&summary$fst<0.6868331),]



png(filename="high_low_fst.divergence.png",width=5,height=3,units='in',res=600)
par(mfrow=c(1,3))
par(mar=c(2,4.5,1,0.5))

wilcox.test(high_fst$dxy,rest$dxy)
wilcox.test(low_fst$dxy,rest$dxy)
boxplot(high_fst$dxy,low_fst$dxy,rest$dxy,xaxt="n",ylab=expression(d[xy]),cex.lab=1.2,notch=TRUE,col=c(colors[8],colors[4],colors[1]))
mtext("***",1,line=0.5,at=c(1,2))

sd(high_fst$fst,na.rm=T)
sd(low_fst$fst,na.rm=T)
sd(rest$fst,na.rm=T)

sd(high_fst$dxy,na.rm=T)
sd(low_fst$dxy,na.rm=T)
sd(rest$dxy,na.rm=T)

wilcox.test(high_fst$dxy_ratio,rest$dxy_ratio)
wilcox.test(low_fst$dxy_ratio,rest$dxy_ratio)
boxplot(high_fst$dxy_ratio,low_fst$dxy_ratio,rest$dxy_ratio,xaxt="n",ylab="RND",cex.lab=1.2,notch=TRUE,col=c(colors[8],colors[4],colors[1]))
mtext("***",1,line=0.5,at=c(1))
mtext("**",1,line=0.5,at=c(2))

sd(high_fst$dxy_ratio,na.rm=T)
sd(low_fst$dxy_ratio,na.rm=T)
sd(rest$dxy_ratio,na.rm=T)
     
     
wilcox.test(high_fst$shared_pro,rest$shared_pro)
wilcox.test(low_fst$shared_pro,rest$shared_pro)
boxplot(high_fst$shared_pro,low_fst$shared_pro,rest$shared_pro,xaxt="n",ylab="Shared(%)",cex.lab=1.2,notch=TRUE,col=c(colors[8],colors[4],colors[1]))
mtext("***",1,line=0.5,at=c(1,2))

sd(high_fst$shared_pro,na.rm=T)
sd(low_fst$shared_pro,na.rm=T)
sd(rest$shared_pro,na.rm=T)

dev.off()

png(filename="high_low_fst.diversity.png",width=5,height=5.5,units='in',res=600)
#p-value < 2.2e-16 ***
#p-value < 1e-4 **
#p-value < 0.05 *


par(mfrow=c(3,2))
par(mar=c(3,5,1,1))

lvl1=c("Divergent","Balancing","Others")
lvl2=c("P.tremula","P.tremuloides")
#lvl2=c(expression(italic("P.tremula")),expression(italic("P.tremuloides")))
factor1=as.factor(rep(c(rep("Divergent",nrow(high_fst)),rep("Balancing",nrow(low_fst)),rep("Others",nrow(rest))),2))
#factor2=as.factor(c(rep(expression(italic("P.tremula")),nrow(rest)+nrow(high_fst)+nrow(low_fst)),rep(expression(italic("P.tremuloides")),nrow(rest)+nrow(high_fst)+nrow(low_fst))))
factor2=as.factor(c(rep("P.tremula",nrow(rest)+nrow(high_fst)+nrow(low_fst)),rep("P.tremuloides",nrow(rest)+nrow(high_fst)+nrow(low_fst))))
plotgrp=factor(paste(factor2,factor1),levels=c(sapply(lvl2,paste,lvl1)))

pi=c(high_fst$tremula_tP.norm,low_fst$tremula_tP.norm,rest$tremula_tP.norm,high_fst$tremuloides_tP.norm,low_fst$tremuloides_tP.norm,rest$tremuloides_tP.norm)
wilcox.test(high_fst$tremula_tP.norm,rest$tremula_tP.norm)
wilcox.test(low_fst$tremula_tP.norm,rest$tremula_tP.norm)
wilcox.test(high_fst$tremuloides_tP.norm,rest$tremuloides_tP.norm)
wilcox.test(low_fst$tremuloides_tP.norm,rest$tremuloides_tP.norm)
sd(high_fst$tremula_tP.norm,na.rm=T)
sd(low_fst$tremula_tP.norm,na.rm=T)
sd(rest$tremula_tP.norm,na.rm=T)
sd(high_fst$tremuloides_tP.norm,na.rm=T)
sd(low_fst$tremuloides_tP.norm,na.rm=T)
sd(rest$tremuloides_tP.norm,na.rm=T)

at_1=c(1:3,5:7)
at=c(2,6)
boxplot(pi~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab=expression(theta[pi]),cex.lab=1,labs=2,col=rep(c(colors[8],colors[4],colors[1]),2))
#axis(1,at=at,labels=lvl2,tick=FALSE)
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=F)
mtext("***",1,line=0.2,at=c(1,2,5,6))


tajD=c(high_fst$tremula_tajD,low_fst$tremula_tajD,rest$tremula_tajD,high_fst$tremuloides_tajD,low_fst$tremuloides_tajD,rest$tremuloides_tajD)
wilcox.test(high_fst$tremula_tajD,rest$tremula_tajD)
wilcox.test(low_fst$tremula_tajD,rest$tremula_tajD)
wilcox.test(high_fst$tremuloides_tajD,rest$tremuloides_tajD)
wilcox.test(low_fst$tremuloides_tajD,rest$tremuloides_tajD)

sd(high_fst$tremula_tajD,na.rm=T)
sd(low_fst$tremula_tajD,na.rm=T)
sd(rest$tremula_tajD,na.rm=T)
sd(high_fst$tremuloides_tajD,na.rm=T)
sd(low_fst$tremuloides_tajD,na.rm=T)
sd(rest$tremuloides_tajD,na.rm=T)

at_1=c(1:3,5:7)
at=c(2,6)
boxplot(tajD~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab="Tajima's D",cex.lab=1,labs=2,col=rep(c(colors[8],colors[4],colors[1]),2))
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=FALSE)
mtext("***",1,line=0.2,at=c(1,5,6))
mtext("**",1,line=0.2,at=c(2))

fayH=c(high_fst$tremula_fayH,low_fst$tremula_fayH,rest$tremula_fayH,high_fst$tremuloides_fayH,low_fst$tremuloides_fayH,rest$tremuloides_fayH)
wilcox.test(high_fst$tremula_fayH,rest$tremula_fayH)
wilcox.test(low_fst$tremula_fayH,rest$tremula_fayH)
wilcox.test(high_fst$tremuloides_fayH,rest$tremuloides_fayH)
wilcox.test(low_fst$tremuloides_fayH,rest$tremuloides_fayH)

sd(high_fst$tremula_fayH,na.rm=T)
sd(low_fst$tremula_fayH,na.rm=T)
sd(rest$tremula_fayH,na.rm=T)
sd(high_fst$tremuloides_fayH,na.rm=T)
sd(low_fst$tremuloides_fayH,na.rm=T)
sd(rest$tremuloides_fayH,na.rm=T)


at_1=c(1:3,5:7)
at=c(2,6)
boxplot(fayH~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab="Fay&Wu's H",cex.lab=1,labs=2,col=rep(c(colors[8],colors[4],colors[1]),2))
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=FALSE)
mtext("***",1,line=0.2,at=c(1,2,5,6))


ld=c(high_fst$tremula_ld,low_fst$tremula_ld,rest$tremula_ld,high_fst$tremuloides_ld,low_fst$tremuloides_ld,rest$tremuloides_ld)
wilcox.test(high_fst$tremula_ld,rest$tremula_ld)
wilcox.test(low_fst$tremula_ld,rest$tremula_ld)
wilcox.test(high_fst$tremuloides_ld,rest$tremuloides_ld)
wilcox.test(low_fst$tremuloides_ld,rest$tremuloides_ld)

sd(high_fst$tremula_ld,na.rm=T)
sd(low_fst$tremula_ld,na.rm=T)
sd(rest$tremula_ld,na.rm=T)
sd(high_fst$tremuloides_ld,na.rm=T)
sd(low_fst$tremuloides_ld,na.rm=T)
sd(rest$tremuloides_ld,na.rm=T)


at_1=c(1:3,5:7)
at=c(2,6)
boxplot(ld~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab=expression(r^2),labs=2,cex.lab=1,col=rep(c(colors[8],colors[4],colors[1]),2))
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=FALSE)
mtext("***",1,line=0.2,at=c(1,5))
mtext("*",1,line=0.2,at=6)

rho_pi=c(high_fst$tremula_ldhat_pi,low_fst$tremula_ldhat_pi,rest$tremula_ldhat_pi,high_fst$tremuloides_ldhat_pi,low_fst$tremuloides_ldhat_pi,rest$tremuloides_ldhat_pi)
wilcox.test(high_fst$tremula_ldhat_pi,rest$tremula_ldhat_pi)
wilcox.test(low_fst$tremula_ldhat_pi,rest$tremula_ldhat_pi)
wilcox.test(high_fst$tremuloides_ldhat_pi,rest$tremuloides_ldhat_pi)
wilcox.test(low_fst$tremuloides_ldhat_pi,rest$tremuloides_ldhat_pi)

sd(high_fst$tremula_ldhat_pi,na.rm=T)
sd(low_fst$tremula_ldhat_pi,na.rm=T)
sd(rest$tremula_ldhat_pi,na.rm=T)
sd(high_fst$tremuloides_ldhat_pi,na.rm=T)
sd(low_fst$tremuloides_ldhat_pi,na.rm=T)
sd(rest$tremuloides_ldhat_pi,na.rm=T)

at_1=c(1:3,5:7)
at=c(2,6)
boxplot(rho_pi~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab=expression(rho/theta[pi]),labs=2,cex.lab=1,col=rep(c(colors[8],colors[4],colors[1]),2))
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=FALSE)
mtext("***",1,line=0.2,at=c(1,5))
mtext("**",1,line=0.2,at=c(2,6))
#mtext("*",1,line=0.2,at=2)


fixed=c(high_fst$tremula_fixed_pro,low_fst$tremula_fixed_pro,rest$tremula_fixed_pro,high_fst$tremuloides_fixed_pro,low_fst$tremuloides_fixed_pro,rest$tremuloides_fixed_pro)
wilcox.test(high_fst$tremula_fixed_pro,rest$tremula_fixed_pro)
wilcox.test(low_fst$tremula_fixed_pro,rest$tremula_fixed_pro)
wilcox.test(high_fst$tremuloides_fixed_pro,rest$tremuloides_fixed_pro)
wilcox.test(low_fst$tremuloides_fixed_pro,rest$tremuloides_fixed_pro)

sd(high_fst$tremula_fixed_pro,na.rm=T)
sd(low_fst$tremula_fixed_pro,na.rm=T)
sd(rest$tremula_fixed_pro,na.rm=T)
sd(high_fst$tremuloides_fixed_pro,na.rm=T)
sd(low_fst$tremuloides_fixed_pro,na.rm=T)
sd(rest$tremuloides_fixed_pro,na.rm=T)

at_1=c(1:3,5:7)
at=c(2,6)
boxplot(fixed~plotgrp,notch=TRUE,at=at_1,xaxt="n",xlab="",ylab="Fixed (%)",labs=2,cex.lab=1,col=rep(c(colors[8],colors[4],colors[1]),2))
axis(1,at=at,labels=c(expression(italic(P.tremula)),expression(italic(P.tremuloides))),tick=FALSE)
mtext("***",1,line=0.2,at=c(1,2,5,6))
dev.off()



####For genomic island estimates, write out the tables 
setwd("/Users/Jing/Dropbox/PaperII/revise_related_paper/data_analysis/genomic_island/")
write.table(high_fst[,c(1,2)],file="high_fst.island",sep="\t",quote=F,row.names=F,col.names=F)
write.table(low_fst[,c(1,2)],file="low_fst.island",sep="\t",quote=F,row.names=F,col.names=F)


###make the plot
high=read.table("high_fst.island.number")
high_island=as.numeric(high$V1)
low=read.table("low_fst.island.number")
low_island=as.numeric(low$V1)
#label
label=c("0-10","10-20","20-30","30-40")
###combine the number of islands for high differentiation and low differnetiation
low_high=rbind(prop.table(high_island),prop.table(low_island))
low_high_table=as.table(low_high)
colnames(low_high_table)=label

png("genomic_island.region.high_low.png",width=5,height=5,units='in',res=500)
barplot(low_high_table,ylim=c(0,1),beside=TRUE,xlab="Size of Regions (Kbp)",ylab="Proportion of Regions",col=c(colors[8],colors[4]))
legend("topright",legend=c("Regions of high differentiation","Regions of low differentiation"),bty="n",fill=c(colors[8],colors[4]))
dev.off()

####
###Number of sites left
png(filename="total_number_sites_left.png",width=4,height=4,units='in',res=300)
par(mfrow=c(1,1))
par(mar=c(4,4.5,1.5,1))
hist(summary$tremula_numSites[which(summary$tremula_numSites>1000 & summary$tremula_numSites<=10000)],breaks=40,xlab="Number of sites",main="",col=colors[1])
abline(v=mean(summary$tremula_numSites[which(summary$tremula_numSites>1000 & summary$tremula_numSites<=10000)]))
dev.off()

png(filename="number_sites.high_low_fst.png",width=4.5,height=6,units='in',res=300)

par(mfrow=c(2,1))
par(mar=c(4,4.5,1.5,1))
sites_mean=mean(summary$tremula_numSites[which(summary$tremula_numSites>1000 & summary$tremula_numSites<=10000)])
hist(high_fst$tremula_numSites[which(high_fst$tremula_numSites>1000 & high_fst$tremula_numSites<10000)],breaks=40,col=colors[8],xlab="Number of sites",main="",xlim=c(1000,10000))
abline(v=sites_mean)
abline(v=mean(high_fst$tremula_numSites[which(high_fst$tremula_numSites>1000 & high_fst$tremula_numSites<10000)]),lty=2)
mtext("(a)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)
hist(low_fst$tremula_numSites[which(low_fst$tremula_numSites>1000 & low_fst$tremula_numSites<10000)],breaks=40,col=colors[4],xlab="Number of sites",main="",xlim=c(1000,10000))
abline(v=sites_mean)
abline(v=mean(low_fst$tremula_numSites[which(low_fst$tremula_numSites>1000 & low_fst$tremula_numSites<10000)]),lty=2)
mtext("(b)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)
dev.off()




####Extract genes
gene=read.table("/Users/Jing/Dropbox/paper2_species_divergence/data/trichocarpa.gene")
names(gene)=c("Chr","Pos","Gene")
setwd("/Users/Jing/Dropbox/PaperII/revise_related_paper/data_analysis/genes/")
###genes within regions of high differentiation
high_gene=merge(gene,high_fst[,c("Chr","Pos")],by=c("Chr","Pos"))[,c("Chr","Pos","Gene")]
write.table(high_gene,file="high_fst.select.gene",sep="\t",quote=F,row.names=F,col.names=F)
low_gene=merge(gene,low_fst[,c("Chr","Pos")],by=c("Chr","Pos"))[,c("Chr","Pos","Gene")]
write.table(low_gene,file="low_fst.select.gene",sep="\t",quote=F,row.names=F,col.names=F)
####remove those windows with number of sites lower than 3kb
low_fst_3kb=low_fst[which(low_fst$tremula_numSites>=3000),]
low_gene_3kb=merge(gene,low_fst_3kb[,c("Chr","Pos")],by=c("Chr","Pos"))[,c("Chr","Pos","Gene")]
write.table(low_gene_3kb,file="low_fst.3kb.select.gene",sep="\t",quote=F,row.names=F,col.names=F)





###Plot the number of genes within each window
rest_g=prop.table(table(rest$Gene_num))
high_fst_g=prop.table(table(high_fst$Gene_num))
low_fst_g=prop.table(table(low_fst$Gene_num))

png(filename="gene.high_low_fst.proportion.png",width=6,height=5,units='in',res=300)
par(mfrow=c(1,1))
par(mar=c(4,4,2,1))
plot(rest_g,type="o",lwd=3,col="light blue",ylim=c(0,0.6),xlab="Number of genes",ylab="Proportion of 10 Kbp windows")
lines(high_fst_g,type="o",col=colors[8],lwd=3)
lines(low_fst_g,type="o",col=colors[4],lwd=3)
legend(2.5,0.55,c("Background","Regions of high differentiation","Regions of low differentiation"),col=c("light blue",colors[8],colors[4]),lwd=2,pch=rep(1,6),lty=c(1,1,1,1,1,1),bty = "n",cex=0.9)
dev.off()



wilcox.test(low_fst$Gene_num,rest$Gene_num,alternative="greater")
wilcox.test(high_fst$Gene_num,rest$Gene_num,alternative="greater")



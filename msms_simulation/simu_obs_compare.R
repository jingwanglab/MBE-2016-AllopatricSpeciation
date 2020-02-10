library(RColorBrewer) 
library(ggplot2)
source("https://bioconductor.org/biocLite.R")
biocLite("qvalue")
library(qvalue)

###colors
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10,11,12)]

setwd("~/Dropbox/PaperII/revise_related_paper/data_analysis")

summary=read.table("tremula_tremuloides.10kb.summary.txt",header=T)
summary$tremula_ldhat_new=summary$tremula_ldhat/1000
summary$tremuloides_ldhat_new=summary$tremuloides_ldhat/1000

summary$tremula_pi_dxy=summary$tremula_tP.norm/summary$dxy
summary$tremuloides_pi_dxy=summary$tremuloides_tP.norm/summary$dxy
summary$dxy_ratio=summary$tremula_tremuloides_dxy/summary$tremula_trichocarpa_dxy
summary$tremula_ldhat_pi=summary$tremula_ldhat_new/summary$tremula_tP.norm
summary$tremuloides_ldhat_pi=summary$tremuloides_ldhat_new/summary$tremuloides_tP.norm

###sub-population of tremuloides
fst_sub=read.table("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremuloides_sub/alb_wil.chr.win.fst.statwindow10000_step10000.fst.dxy.txt",header=T)
hist(fst_sub$Fst,breaks=100)

###simulation data
simu_fst=read.table("tremula.tremuloides.fst",header=F)
simu_tremula=read.table("tremula.total.thetas.gz.pestPG",header=F)
simu_tremula_pi=simu_tremula[!is.na(simu_tremula$V4),]
simu_tremuloides_pi=read.table("tremuloides.total.thetas.gz.pestPG",header=F)

df=data.frame(value=c(simu_fst$V2,summary$fst[which(summary$fst!="NA")]),group=c(rep("sim",length(simu_fst$V2)),rep("obs",length(summary$fst[which(summary$fst!="NA")]))))
ggplot(df)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme(legend.position="none")+theme_bw()+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab(expression(F[ST]))
ggsave(filename="fst.obs_sim.png",width=5,height=4.5,dpi=300)

tremula_pi=data.frame(value=c(simu_tremula_pi$V5/simu_tremula_pi$V14,summary$tremula_tP.norm[which(summary$tremula_tP.norm!="NA")]),group=c(rep("sim",nrow(simu_tremula_pi)),rep("obs",length(summary$tremula_tP.norm[which(summary$tremula_tP.norm!="NA")]))))
ggplot(tremula_pi)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme(legend.position="none")+theme_bw()+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab(expression(theta[pi]))
ggsave(filename="tremula_pi.obs_sim.png",width=5,height=4.5,dpi=300)

tremula_tajD=data.frame(value=c(simu_tremula_pi$V9,summary$tremula_tajD[which(summary$tremula_tajD!="NA")]),group=c(rep("sim",nrow(simu_tremula_pi)),rep("obs",length(summary$tremula_tajD[which(summary$tremula_tajD!="NA")]))))
ggplot(tremula_tajD)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme(legend.position="none")+theme_bw()+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab("Tajima's D")
ggsave(filename="tremula_tajD.obs_sim.png",width=5,height=4.5,dpi=300)


tremuloides_pi=data.frame(value=c(simu_tremuloides_pi$V5/simu_tremuloides_pi$V14,summary$tremuloides_tP.norm[which(summary$tremuloides_tP.norm!="NA")]),group=c(rep("sim",nrow(simu_tremuloides_pi)),rep("obs",length(summary$tremuloides_tP.norm[which(summary$tremuloides_tP.norm!="NA")]))))
ggplot(tremuloides_pi)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme(legend.position="none")+theme_bw()+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab(expression(theta[pi]))
ggsave(filename="tremuloides_pi.obs_sim.png",width=5,height=4.5,dpi=300)

tremuloides_tajD=data.frame(value=c(simu_tremuloides_pi$V9,summary$tremuloides_tajD[which(summary$tremuloides_tajD!="NA")]),group=c(rep("sim",nrow(simu_tremuloides_pi)),rep("obs",length(summary$tremuloides_tajD[which(summary$tremuloides_tajD!="NA")]))))
ggplot(tremuloides_tajD)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme(legend.position="none")+theme_bw()+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab("Tajima's D")
ggsave(filename="tremuloides_tajD.obs_sim.png",width=5,height=4.5,dpi=300)


####plot compaing the true mean value and 
#Predictive distributions of 500,000 simulated values of π, Tajima’s D, and Fst under the best demographic model predicted for both tremula and tremuloides
simu_tremula_pi_new=simu_tremula_pi[which(simu_tremula_pi$V5<500),]
simu_tremuloides_pi_new=simu_tremuloides_pi[which((simu_tremuloides_pi$V5<500) & (simu_tremuloides_pi$V9<-2.6)),]

png(filename="simu_obs.pi_tajD.png",width=5,height=5,units='in',res=300)
par(mfrow=c(2,2))
par(mar=c(4,4,1.5,1))
hist(simu_tremula_pi_new$V5/simu_tremula_pi_new$V14,breaks=100,xlim=c(0,0.025),xlab=expression(theta[pi]),main="")
abline(v=median(summary$tremula_tP.norm,na.rm=T),col="red",lwd=3)
mtext("(a)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(simu_tremula_pi_new$V9,breaks=70,xlab="Tajima's D",main="",xlim=c(-2,2))
abline(v=median(summary$tremula_tajD,na.rm=T),col="red",lwd=3)
mtext("(b)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(simu_tremuloides_pi_new$V5/simu_tremuloides_pi_new$V14,breaks=100,xlim=c(0,0.025),xlab=expression(theta[pi]),main="")
abline(v=median(summary$tremuloides_tP.norm,na.rm=T),col="red",lwd=3)
mtext("(c)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(simu_tremuloides_pi_new$V9,breaks=50,xlab="Tajima's D",main="",xlim=c(-2.7,1))
abline(v=median(summary$tremuloides_tajD,na.rm=T),col="red",lwd=3)
mtext("(d)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)
dev.off()


png(filename="simu_obs.fst.png",width=5,height=5,units='in',res=300)
par(mfrow=c(1,1))
par(mar=c(4,4,1.5,1))
hist(simu_fst$V2,breaks=50,xlab=expression(F[ST]),main="")
abline(v=median(summary$fst,na.rm=T),col="red",lwd=3)
dev.off()

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

####detect extremly low fst
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







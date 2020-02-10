library(RColorBrewer) 
library(ggplot2)
source("https://bioconductor.org/biocLite.R")
biocLite("qvalue")
library(qvalue)

###colors
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

###sub-population of tremuloides
fst_sub=read.table("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremuloides_sub/alb_wil.chr.win.fst.statwindow10000_step10000.fst.dxy.txt",header=T)
hist(fst_sub$Fst,breaks=100)
sub_pi=read.table("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremuloides_sub/tremuloides_alb_wil.10000bp10000bp.thetas.txt",header=T)

###simulation data
##fst from the 3 models
simu_fst=read.table("tremula.tremuloides.fst",header=F)
simu_3pop_fst=read.table("tremula.tremuloides.3pop.fst",header=F)
simu_3pop_high_gf_fst=read.table("tremula.tremuloides.3pop_high_gf.fst",header=F)
simu_tremuloides_fst=read.table("tremuloides.3pop.fst",header=F)
simu_tremuloides_high_gf_fst=read.table("tremuloides.3pop_high_gf.fst",header=F)

###diversity and Tajima'D
simu_tremula_pi=read.table("tremula.total.pestPG",header=F)
#simu_tremula_pi=simu_tremula[!is.na(simu_tremula$V4),]
simu_tremuloides_pi=read.table("tremuloides.total.pestPG",header=F)

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
hist(simu_tremula_pi_new$V5/simu_tremula_pi_new$V14,breaks=100,xlim=c(0.005,0.025),xlab=expression(theta[pi]),main="")
abline(v=median(summary$tremula_tP.norm,na.rm=T),col="red",lwd=3)
mtext("(a)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(simu_tremula_pi_new$V9,breaks=70,xlab="Tajima's D",main="",xlim=c(-2,2))
abline(v=median(summary$tremula_tajD,na.rm=T),col="red",lwd=3)
mtext("(b)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(simu_tremuloides_pi_new$V5/simu_tremuloides_pi_new$V14,breaks=100,xlim=c(0.005,0.025),xlab=expression(theta[pi]),main="")
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



###compare fst for three models,
##model1: do not consider population subdivision in P.tremuloides
##model2:consider population subdivision in P.tremuloides, but assume no gene flow between the two subpopulations
##model3:consider population subdivision in P.tremuloides, but assume gene flow between the two subpopulations is 4Nem=10 in both directions

model1=sample(simu_fst$V2,100000,replace=F)
model2=sample(simu_3pop_fst$V2,100000,replace=F)
model3=sample(simu_3pop_high_gf_fst$V2,100000,replace=F)

#fst_3model=data.frame(value=c(model1,model2,model3,summary$fst[which(summary$fst!="NA")]),group=c(rep("Model1",length(model1)),rep("Model2",length(model2)),rep("Model3",length(model3)),rep("Obs",length(summary$fst[which(summary$fst!="NA")]))))
fst_3model=data.frame(value=c(model1,model2,model3),group=c(rep("Model1",length(model1)),rep("Model2",length(model2)),rep("Model3",length(model3))))
ggplot(fst_3model)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme_bw()+xlab(expression(F[ST]))+geom_vline(xintercept = median(summary$fst,na.rm=T),colour="black")
ggsave(filename="fst_sim.3models.png",width=5,height=4.5,dpi=300)
#theme(legend.position="none")+scale_fill_manual(values=c("#1F78B4","grey60"),labels=c("Obs","Sim"))+xlab(expression(F[ST]))

###tremuloides_subpop_fst

subpop_fst_2model=data.frame(value=c(simu_tremuloides_fst$V2,simu_tremuloides_high_gf_fst$V2,fst_sub$Fst),group=c(rep("Model2",length(simu_tremuloides_fst$V2)),rep("Model3",length(simu_tremuloides_high_gf_fst$V2)),rep("Obs",length(fst_sub$Fst))))
ggplot(subpop_fst_2model)+stat_density(aes(x=value,fill=group),alpha=.5,position="dodge")+theme_bw()+xlab(expression(F[ST]))+xlim(0,0.2)
ggsave(filename="tremuloides.fst_sim.png",width=5,height=4.5,dpi=300)






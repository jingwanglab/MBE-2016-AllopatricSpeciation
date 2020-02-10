library(RColorBrewer)
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10,11,12)]

summary=read.table("~/Dropbox/paperII/paper/version3/data/tremula_tremuloides.10kb.summary.txt",header=T)
summary$tremula_ldhat_new=summary$tremula_ldhat/1000
summary$tremuloides_ldhat_new=summary$tremuloides_ldhat/1000

summary$tremula_pi_dxy=summary$tremula_tP.norm/summary$dxy
summary$tremuloides_pi_dxy=summary$tremuloides_tP.norm/summary$dxy
summary$dxy_ratio=summary$tremula_tremuloides_dxy/summary$tremula_trichocarpa_dxy
summary$tremula_ldhat_pi=summary$tremula_ldhat_new/summary$tremula_tP.norm
summary$tremuloides_ldhat_pi=summary$tremuloides_ldhat_new/summary$tremuloides_tP.norm

###high fst
high=0.686833
low=0.134439
###fst categories
high_fst=summary[which(summary$fst>high & summary$fst!="NA"),]
low_fst=summary[which(summary$fst<low & summary$fst!="NA"),]
rest=summary[-which((summary$fst>=high | summary$fst<=low)),]

###100Kbp
total_100kb=read.table("~/Dropbox/paperI/data/100kb/100kb.summary.txt",header=T)

total_100kb$tremula_ldhat_new=total_100kb$Ldhat_tremula/1000
total_100kb$tremuloides_ldhat_new=total_100kb$Ldhat_tremuloides/1000
total_100kb$trichocarpa_ldhat_new=total_100kb$Ldhat_trichocarpa/1000

total_100kb[which(total_100kb$Ldhat_tremula_num<50),]$tremula_ldhat_new="NA"
total_100kb[which(total_100kb$Ldhat_tremuloides_num<50),]$tremuloides_ldhat_new="NA"
total_100kb[which(total_100kb$Ldhat_trichocarpa_num<50),]$trichocarpa_ldhat_new="NA"

chr_fst=as.list(matrix(,19))
chr_fst_pos=as.list(matrix(,19))
fst_tremula_tremuloides=as.list(matrix(,19))

for (i in 1:19) {
  if (i<10) {
    j=paste("Chr","0",i,sep="")
  }
  else {
    j=paste("Chr",i,sep="")
  }
  chr_fst_pos[[i]]=total_100kb$Pos[total_100kb$Chr==j]
  fst_tremula_tremuloides[[i]]=total_100kb$tremula_tremuloides_fst[total_100kb$Chr==j]
}

###fst window plot
mat=matrix(c(1,0,2,3),2,byrow=TRUE)
layout=layout(mat,c(4,1),c(1,4))

nf <- layout(matrix(c(2,0,1,3),2,2,byrow=TRUE), widths=c(6,1), heights=c(1,6), TRUE)

chr=as.list(matrix(,19))
chr_pos=as.list(matrix(,19))
pi_tremula=as.list(matrix(,19))
pi_tremuloides=as.list(matrix(,19))
tajD_tremula=as.list(matrix(,19))
tajD_tremuloides=as.list(matrix(,19))
fayH_tremula=as.list(matrix(,19))
fayH_tremuloides=as.list(matrix(,19))
ld_tremula=as.list(matrix(,19))
ld_tremuloides=as.list(matrix(,19))
fixed_tremula=as.list(matrix(,19))
fixed_tremuloides=as.list(matrix(,19))
shared=as.list(matrix(,19))
fst=as.list(matrix(,19))
dxy=as.list(matrix(,19))

for (i in 1:19) { 
  if (i<10) {
    chr[[i]]=paste("Chromosome ","0",i,sep="")
  }
  else {
    chr[[i]]=paste("Chromosome ",i,sep="")
  }
  chr_pos[[i]]=summary$Pos[summary$Chr==i]
  pi_tremula[[i]]=summary$tremula_tP.norm[summary$Chr==i]
  pi_tremuloides[[i]]=summary$tremuloides_tP.norm[summary$Chr==i]
  tajD_tremula[[i]]=summary$tremula_tajD[summary$Chr==i]
  tajD_tremuloides[[i]]=summary$tremuloides_tajD[summary$Chr==i]
  fayH_tremula[[i]]=summary$tremula_fayH[summary$Chr==i]
  fayH_tremuloides[[i]]=summary$tremuloides_fayH[summary$Chr==i]
  ld_tremula[[i]]=summary$tremula_ld[summary$Chr==i]
  ld_tremuloides[[i]]=summary$tremuloides_ld[summary$Chr==i]
  fixed_tremula[[i]]=summary$tremula_fixed_pro[summary$Chr==i]
  fixed_tremuloides[[i]]=summary$tremuloides_fixed_pro[summary$Chr==i]
  shared[[i]]=summary$shared_pro[summary$Chr==i]
  fst[[i]]=summary$fst[summary$Chr==i]
  dxy[[i]]=summary$dxy[summary$Chr==i]
}
ma <- function(x,n){filter(x,rep(1/n,n), sides=2)}
#fst_q0.975=quantile(summary$fst,0.975,na.rm=TRUE)
#fst_q0.025=quantile(summary$fst,0.025,na.rm=TRUE)

png("high_fst.sliding.window.png",width = 8, height = 5.8, units = 'in', res=500)
mat=matrix(c(rep(1,49),rep(2,25),rep(0,1),rep(3,21),rep(4,24),rep(5,26),rep(0,4),rep(6,28),rep(7,16),rep(8,20),rep(0,11),rep(9,13),rep(10,22),rep(11,14),rep(12,16),rep(0,10),rep(13,16),rep(14,13),rep(15,15),rep(16,15),rep(0,16),rep(17,16),rep(18,17),rep(19,16),rep(0,26)),byrow=T,nrow=6)
layout(mat)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[1]]/1e6,fst[[1]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==1]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==1])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==1]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==1])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[1]]/1e6,fst_tremula_tremuloides[[1]],col="grey30")
#lines(chr_pos[[1]]/1e6,ma(fst[[1]],n=10),col="grey30")
axis(labels=NA,side=1,tck=-0.015,pos=0)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr01",side=1,cex=0.5,line=0.2)
#axis(side=1,at=seq(0,max(chr_pos[[1]]/1e6)+2,5),cex.axis=1.0)
#mtext(expression(F[ST]),side=2,cex=0.7,line=2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[2]]/1e6,fst[[2]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==2]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==2])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==2]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==2])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[2]]/1e6,fst_tremula_tremuloides[[2]],col="grey30")

#lines(chr_pos[[2]]/1e6,ma(fst[[2]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015,pos=0)
mtext("Chr02",side=1,cex=0.5,line=0.2)
#axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
#mtext(expression(F[ST]),side=2,cex=0.7,line=2)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[3]]/1e6,fst[[3]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==3]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==3])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==3]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==3])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[3]]/1e6,fst_tremula_tremuloides[[3]],col="grey30")

#lines(chr_pos[[3]]/1e6,ma(fst[[3]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015,pos=0)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr03",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[4]]/1e6,fst[[4]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==4]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==4])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==4]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==4])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[4]]/1e6,fst_tremula_tremuloides[[4]],col="grey30")

#lines(chr_pos[[4]]/1e6,ma(fst[[4]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr04",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[5]]/1e6,fst[[5]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==5]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==5])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==5]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==5])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[5]]/1e6,fst_tremula_tremuloides[[5]],col="grey30")

#lines(chr_pos[[5]]/1e6,ma(fst[[5]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr05",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[6]]/1e6,fst[[6]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==6]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==6])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==6]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==6])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[6]]/1e6,fst_tremula_tremuloides[[6]],col="grey30")

#lines(chr_pos[[6]]/1e6,ma(fst[[6]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr06",side=1,cex=0.5,line=0.2)
#axis(side=1,at=seq(0,max(chr_pos[[1]]/1e6)+2,5),cex.axis=1.0)
mtext(expression(F[ST]),side=3,cex=0.8,line=-0.5,padj=6.3,adj=-0.22)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[7]]/1e6,fst[[7]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==7]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==7])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==7]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==7])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[7]]/1e6,fst_tremula_tremuloides[[7]],col="grey30")

#lines(chr_pos[[7]]/1e6,ma(fst[[7]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr07",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[8]]/1e6,fst[[8]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==8]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==8])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==8]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==8])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[8]]/1e6,fst_tremula_tremuloides[[8]],col="grey30")

#lines(chr_pos[[8]]/1e6,ma(fst[[8]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr08",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[9]]/1e6,fst[[9]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==9]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==9])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==9]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==9])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[9]]/1e6,fst_tremula_tremuloides[[9]],col="grey30")

#lines(chr_pos[[9]]/1e6,ma(fst[[9]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr09",side=1,cex=0.5,line=0.2)
#axis(side=1,at=seq(0,max(chr_pos[[1]]/1e6)+2,5),cex.axis=1.0)
#mtext(expression(F[ST]),side=2,cex=0.7,line=2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[10]]/1e6,fst[[10]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==10]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==10])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==10]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==10])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[10]]/1e6,fst_tremula_tremuloides[[10]],col="grey30")

#lines(chr_pos[[10]]/1e6,ma(fst[[10]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr10",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[11]]/1e6,fst[[11]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==11]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==11])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==11]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==11])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[11]]/1e6,fst_tremula_tremuloides[[11]],col="grey30")

#lines(chr_pos[[11]]/1e6,ma(fst[[11]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr11",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[12]]/1e6,fst[[12]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==12]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==12])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==12]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==12])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[12]]/1e6,fst_tremula_tremuloides[[12]],col="grey30")

#lines(chr_pos[[12]]/1e6,ma(fst[[12]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr12",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[13]]/1e6,fst[[13]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==13]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==13])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==13]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==13])),col=colors[4],cex=1,pch="|",lwd=2)

lines(chr_fst_pos[[13]]/1e6,fst_tremula_tremuloides[[13]],col="grey30")

#lines(chr_pos[[13]]/1e6,ma(fst[[13]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr13",side=1,cex=0.5,line=0.2)
#axis(side=1,at=seq(0,max(chr_pos[[1]]/1e6)+2,5),cex.axis=1.0)
#mtext(expression(F[ST]),side=2,cex=0.7,line=2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[14]]/1e6,fst[[14]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==14]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==14])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==14]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==14])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[14]]/1e6,fst_tremula_tremuloides[[14]],col="grey30")

#lines(chr_pos[[14]]/1e6,ma(fst[[14]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr14",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[15]]/1e6,fst[[15]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==15]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==15])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==15]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==15])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[15]]/1e6,fst_tremula_tremuloides[[15]],col="grey30")

#lines(chr_pos[[15]]/1e6,ma(fst[[15]],n=11),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr15",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[16]]/1e6,fst[[16]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==16]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==16])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==16]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==16])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[16]]/1e6,fst_tremula_tremuloides[[16]],col="grey30")

#lines(chr_pos[[16]]/1e6,ma(fst[[16]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr16",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,4,0.5,0.5))
plot(chr_pos[[17]]/1e6,fst[[17]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==17]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==17])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==17]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==17])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[17]]/1e6,fst_tremula_tremuloides[[17]],col="grey30")

#lines(chr_pos[[17]]/1e6,ma(fst[[17]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
axis(side=2,at=seq(0,1,0.2),cex.axis=0.7)
mtext("Chr17",side=1,cex=0.5,line=0.2)
#axis(side=1,at=seq(0,max(chr_pos[[1]]/1e6)+2,5),cex.axis=1.0)
#mtext(expression(F[ST]),side=2,cex=0.7,line=2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[18]]/1e6,fst[[18]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==18]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==18])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==18]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==18])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[18]]/1e6,fst_tremula_tremuloides[[18]],col="grey30")

#lines(chr_pos[[18]]/1e6,ma(fst[[18]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr18",side=1,cex=0.5,line=0.2)

par(mar=c(1.5,1,0.5,0.5))
plot(chr_pos[[19]]/1e6,fst[[19]],axes=F,col="light blue",xlab="",ylab="",xaxt="n",pch=19,cex=.1,ylim=c(0,1.3))
points(high_fst$Pos[high_fst$Chr==19]/1e6,rep(1.2,length(high_fst$Pos[high_fst$Chr==19])),col=colors[8],cex=1,pch="|",lwd=2)
points(low_fst$Pos[low_fst$Chr==19]/1e6,rep(1.0,length(low_fst$Pos[low_fst$Chr==19])),col=colors[4],cex=1,pch="|",lwd=2)
lines(chr_fst_pos[[19]]/1e6,fst_tremula_tremuloides[[19]],col="grey30")

#lines(chr_pos[[19]]/1e6,ma(fst[[19]],n=7),col="grey30")
axis(labels=NA,side=1,tck=-0.015)
mtext("Chr19",side=1,cex=0.5,line=0.2)

#mtext("| Hard sweeps in both species",col="black",side=3,cex=.7,line=0.8,padj=4,adj=100)
##mtext("| Hard sweeps in P.tremula",col=colors[6],side=3,cex=.7,line=0.7,padj=7,adj=15)
#mtext("| Hard sweeps in P.tremuloides",col=colors[2],side=3,cex=.7,line=0.7,padj=7,adj=35)
#mtext("| Soft sweeps in either species",col="grey30",side=3,cex=.7,line=0.7,padj=1,adj=0.5)
#mtext("| Balancing selection in both species",col=colors[4],side=3,cex=1,line=0.7,padj=13,adj=6)


dev.off()




###compare fst for three models,
##model1: do not consider population subdivision in P.tremuloides
##model2:consider population subdivision in P.tremuloides, but assume no gene flow between the two subpopulations
##model3:consider population subdivision in P.tremuloides, but assume gene flow between the two subpopulations is 4Nem=10 in both directions


model2_tremula=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop/summary/tremula.3pop.total.pestPG")
model2_tremuloides=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop/summary/tremuloides.3pop.total.pestPG")
model2_tremuloides_pop1=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop/summary/tremuloides.1.3pop.total.pestPG")
model2_tremuloides_pop2=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop/summary/tremuloides.2.3pop.total.pestPG")

model3_tremula=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop_high_gene_flow/summary/tremula.3pop.total.pestPG")
model3_tremuloides=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop_high_gene_flow/summary/tremuloides.3pop.total.pestPG")
model3_tremuloides_pop1=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop_high_gene_flow/summary/tremuloides.1.3pop.total.pestPG")
model3_tremuloides_pop2=read.table("/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms_3pop_high_gene_flow/summary/tremuloides.2.3pop.total.pestPG")

###In each model, randomly select 100,000 simulated samples
model2_tremula_new=sample(model2_tremula,100000,replace=F)
model2_tremuloides_new=sample(model2_tremuloides,100000,replace=F)
model2_tremuloides_pop1_new=sample(model2_tremuloides_pop1,100000,replace=F)
model2_tremuloides_pop2_new=sample(model2_tremuloides_pop2,100000,replace=F)

model3_tremula_new=sample(model3_tremula,100000,replace=F)
model3_tremuloides_new=sample(model3_tremuloides,100000,replace=F)
model3_tremuloides_pop1_new=sample(model3_tremuloides_pop1,100000,replace=F)
model3_tremuloides_pop2_new=sample(model3_tremuloides_pop2,100000,replace=F)



png(filename="tremuloides.sub.pi_tajD.png",width=7.5,height=5,units='in',res=300)
par(mfrow=c(2,4))
par(mar=c(4,5,1.5,1))

hist(model2_tremula$V5/model2_tremula$V14,freq=F,breaks=500,xlim=c(0,0.025),xlab=expression(italic(P.tremula)),main="",col=rgb(0.3,0.3,0.3,0.3))
hist(model3_tremula$V5/model3_tremula$V14,freq=F,breaks=500,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=0.0130356,col="red",lwd=3)
mtext("(a)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(model2_tremuloides$V5/model2_tremuloides$V14,freq=F,breaks=500,xlim=c(0.005,0.025),xlab=expression(italic(P.tremuloides)),main="",col=rgb(0.3,0.3,0.3,0.3))
hist(model3_tremuloides$V5/model3_tremuloides$V14,freq=F,breaks=500,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=0.01433462,col="red",lwd=3)

hist(model2_tremuloides_pop1$V5/model2_tremuloides_pop1$V14,freq=F,breaks=500,xlim=c(0.005,0.025),xlab="Alberta",main="",col=rgb(0.3,0.3,0.3,0.3))
hist(model3_tremuloides_pop1$V5/model3_tremuloides_pop1$V14,freq=F,breaks=500,col=rgb(0.8,0.8,0.8,0.3), add=T)
abline(v=0.01442964,col="red",lwd=3)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)

hist(model2_tremuloides_pop2$V5/model2_tremuloides_pop2$V14,freq=F,breaks=500,xlim=c(0.005,0.025),xlab="Wisconsin",main="",col=rgb(0.3,0.3,0.3,0.3))
hist(model3_tremuloides_pop2$V5/model3_tremuloides_pop2$V14,freq=F,breaks=600,col=rgb(0.8,0.8,0.8,0.3), add=T)
abline(v=0.01401584,col="red",lwd=3)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)

###Tajima's D
hist(model2_tremula$V9,freq=F,breaks=60,xlim=c(-2,2),xlab=expression(italic(P.tremula)),main="",col=rgb(0.3,0.3,0.3,0.3))
hist(model3_tremula$V9,freq=F,breaks=60,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=-0.32094,col="red",lwd=3)
mtext("(b)",side=3,line=0.05,adj=-0.28,font=1.5,cex=1)

hist(model2_tremuloides$V9,freq=F,breaks=60,xlim=c(-2.5,0.5),xlab=expression(italic(P.tremuloides)),main="",col=rgb(0.3,0.3,0.3,0.3),ylim=c(0,1.3))
hist(model3_tremuloides$V9,freq=F,breaks=50,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=-1.206518,col="red",lwd=3)

hist(model2_tremuloides_pop1$V9,freq=F,breaks=60,xlim=c(-2.5,0.5),xlab="Alberta",main="",col=rgb(0.3,0.3,0.3,0.3),ylim=c(0,1.2))
hist(model3_tremuloides_pop1$V9,freq=F,breaks=50,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=-0.987227,col="red",lwd=3)

hist(model2_tremuloides_pop2$V9,freq=F,breaks=60,xlim=c(-2.5,0.5),xlab="Wisconsin",main="",col=rgb(0.3,0.3,0.3,0.3),ylim=c(0,1.2))
hist(model3_tremuloides_pop2$V9,freq=F,breaks=50,col=rgb(0.8,0.8,0.8,0.3), add=T)
legend("topright",legend=c("Model2","Model3"),fill=c(rgb(0.3,0.3,0.3,0.3),rgb(0.8,0.8,0.8,0.3)),bty="n",cex=0.6)
abline(v=-0.77864,col="red",lwd=3)

dev.off()



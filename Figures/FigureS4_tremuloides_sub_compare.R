library(RColorBrewer) 
library(ggplot2)
source("https://bioconductor.org/biocLite.R")
biocLite("qvalue")
library(qvalue)

###colors
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10,11,12)]

setwd("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremuloides_sub/")

summary=read.table("~/Dropbox/PaperII/revise_related_paper/data_analysis/tremula_tremuloides.10kb.summary.txt",header=T)
summary$tremula_ldhat_new=summary$tremula_ldhat/1000
summary$tremuloides_ldhat_new=summary$tremuloides_ldhat/1000

summary$tremula_pi_dxy=summary$tremula_tP.norm/summary$dxy
summary$tremuloides_pi_dxy=summary$tremuloides_tP.norm/summary$dxy
summary$dxy_ratio=summary$tremula_tremuloides_dxy/summary$tremula_trichocarpa_dxy
summary$tremula_ldhat_pi=summary$tremula_ldhat_new/summary$tremula_tP.norm
summary$tremuloides_ldhat_pi=summary$tremuloides_ldhat_new/summary$tremuloides_tP.norm

###tremuloides_subpopulation
tremuloides_sub=read.table("tremuloides_alb_wil.10000bp10000bp.thetas.txt",header=T)


png(filename="tremuloides_sub_tajD_fayH.png",width=6,height=7,units='in',res=300)
par(mfrow=c(3,1))
par(mar=c(3,5,2,1))

boxplot(summary$tremula_tP.norm,summary$tremuloides_tP.norm,tremuloides_sub$alb_tP.norm,tremuloides_sub$wil_tP.norm,col=c(colors[6],colors[2],colors[4],colors[10]),ylab=expression(theta[pi]),names=c(expression(italic(P.tremula)),expression(italic(P.tremuloides)),"Alberta","Wisconsin"))
#abline(h=0,lty=2,col="grey")
mtext("(a)",side=3,line=0.05,adj=-0.1,font=1.5,cex=1.5)

boxplot(summary$tremula_tajD,summary$tremuloides_tajD,tremuloides_sub$alb_tajD,tremuloides_sub$wil_tajD,col=c(colors[6],colors[2],colors[4],colors[10]),ylab="Tajima's D",names=c(expression(italic(P.tremula)),expression(italic(P.tremuloides)),"Alberta","Wisconsin"))
abline(h=0,lty=2,col="grey")
mtext("(b)",side=3,line=0.05,adj=-0.1,font=1.5,cex=1.5)

boxplot(summary$tremula_fayH,summary$tremuloides_fayH,tremuloides_sub$alb_fayH,tremuloides_sub$wil_fayH,col=c(colors[6],colors[2],colors[4],colors[10]),ylab="Fay&Wu's H",names=c(expression(italic(P.tremula)),expression(italic(P.tremuloides)),"Alberta","Wisconsin"))
abline(h=0,lty=2,col="grey")
wilcox.test(tremuloides_sub$alb_fayH,tremuloides_sub$wil_fayH)
mtext("(c)",side=3,line=0.05,adj=-0.1,font=1.5,cex=1.5)
dev.off()



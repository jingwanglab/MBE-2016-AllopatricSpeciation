setwd("~/Dropbox/PaperII/divergence_figure/population_structure/pie_plot")

#GATK output
total=5838837
shared=966806
tremula_private=1866307
tremula_fixed=65649
tremuloides_private=2891999
tremuloides_fixed=48084
fixed=tremula_fixed+tremuloides_fixed

summary=c(shared,tremula_private,tremuloides_private,fixed)
labels=c("Shared","P.tremula\nPolymorphic","P.tremuloides\nPolymorphic","Fixed")
percent=round(summary/sum(summary)*100,digits=1)
labels_1=paste(labels,percent)
labels_2=paste(labels_1,"%",sep=" ")
pie(summary,labels_2,col=c(rgb(0,0,1,0.5),rgb(1,0,0,0.5),rgb(0,1,0,0.5),rgb(0,1,1,0.5)))


#ANGSD output
library(RColorBrewer)
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10)]



shared_angsd=16.7
tremula_private_angsd=32.0
tremuloides_private_angsd=50.2
fixed_angsd=1.1
labels=c("Shared","P.tremula","P.tremuloides","Fixed")
percent_angsd=c(shared_angsd,tremula_private_angsd,tremuloides_private_angsd,fixed_angsd)
labels_1=paste(labels,percent_angsd)
labels_2=paste(labels_1,"%",sep=" ")

#pdf("angsd_pie.pdf")
png(filename="sig_snps.anno_pie.png",width = 5, height = 5, units = 'in', res=300)
par(mfrow=c(1,1))
par(oma=c(0,0,0,0))
par(mgp=c(2,1,0))
par(mar=c(0,2,0,4))
#pie(percent_angsd,labels_2,col=c(rgb(0,0,1,0.5),rgb(1,0,0,0.5),rgb(0,1,0,0.5),rgb(0,1,1,0.5)))
pie(percent_angsd,labels=c("Shared (16.7%)",expression(paste(italic(P.tremula)," (32.0%)")),expression(paste(italic(P.tremuloides)," (50.2%)")),"Fixed (1.1%)"),cex=1.4,border=NA,edges=100,col=c(colors[10],colors[6],colors[2],colors[4]))
dev.off()
 
 




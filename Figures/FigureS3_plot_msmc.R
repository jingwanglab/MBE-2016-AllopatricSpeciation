＃install.packages("Hmisc")
library(Hmisc)
library(RColorBrewer)
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10)]

minor.ticks.axis <- function(ax,n,t.ratio=0.5,mn,mx,...){
  
  lims <- par("usr")
  if(ax %in%c(1,3)) lims <- lims[1:2] else lims[3:4]
  
  major.ticks <- pretty(lims,n=5)
  if(missing(mn)) mn <- min(major.ticks)
  if(missing(mx)) mx <- max(major.ticks)
  
  major.ticks <- major.ticks[major.ticks >= mn & major.ticks <= mx]
  
  labels <- sapply(major.ticks,function(i)
    as.expression(bquote(10^ .(i)))
  )
  axis(ax,at=major.ticks,labels=labels,...)
  
  n <- n+2
  minors <- log10(pretty(10^major.ticks[1:2],n))-major.ticks[1]
  minors <- minors[-c(1,n)]
  
  minor.ticks = c(outer(minors,major.ticks,`+`))
  minor.ticks <- minor.ticks[minor.ticks > mn & minor.ticks < mx]
  
  
  axis(ax,at=minor.ticks,tcl=par("tcl")*t.ratio,labels=FALSE)
}


setwd("~/Dropbox/PaperII/revise_related_paper/data_analysis/msmc/tremuloides_subdivision")
alb_2hap=read.table("alb.2hap.msmc.output.plot.txt",header=T)
wil_2hap=read.table("wil.2hap.msmc.output.plot.txt",header=T)
alb_4hap=read.table("alb.4hap.msmc.output.plot.txt",header=T)
wil_4hap=read.table("wil.4hap.msmc.output.plot.txt",header=T)
alb_8hap=read.table("alb.8hap.msmc.output.plot.txt",header=T)
wil_8hap=read.table("wil.8hap.msmc.output.plot.txt",header=T)
tremuloides_2hap=read.table("tremuloides.2hap.msmc.output.plot.txt",header=T)
tremuloides_4hap=read.table("tremuloides.4hap.msmc.output.plot.txt",header=T)
tremuloides_8hap=read.table("tremuloides.8hap.msmc.output.plot.txt",header=T)
tremula_2hap=read.table("tremula.2hap.msmc.output.plot.txt",header=T)
tremula_4hap=read.table("tremula.4hap.msmc.output.plot.txt",header=T)
tremula_8hap=read.table("tremula.8hap.msmc.output.plot.txt",header=T)

alb_8hap_new=alb_8hap[2:38,]
wil_8hap_new=wil_8hap[2:38,]
tremuloides_8hap_new=tremuloides_8hap[2:38,]
tremula_8hap_new=tremula_8hap[2:38,]
alb_4hap_new=alb_4hap[2:38,]
wil_4hap_new=wil_4hap[2:38,]
tremuloides_4hap_new=tremuloides_4hap[2:38,]
tremula_4hap_new=tremula_4hap[2:38,]
alb_2hap_new=alb_2hap[2:38,]
wil_2hap_new=wil_2hap[2:38,]
tremuloides_2hap_new=tremuloides_2hap[2:38,]
tremula_2hap_new=tremula_2hap[2:38,]

pdf("alb_wil.msmc.pdf")
par(mfrow=c(1,1))
plot(log10(alb_2hap_new$left_time_boundary),log10(alb_2hap_new$lambda_00),type="s",lwd=3,lty=2,xlim=c(3,6.5),ylim=c(4,7.5),col=colors[4],xaxt='n',yaxt='n',xlab="Time (years ago)",ylab="Effective population size")

axis(side=1,at=c(3,4,5,6),labels=c(expression(10^3),expression(10^4),expression(10^5),expression(10^6)))
minor.ticks.axis(1,9,tick.mn=3,mx=6.5)


axis(side=2,at=c(4,5,6,7),labels=c(expression(10^4),expression(10^5),expression(10^6),expression(10^7)))
minor.ticks.axis(2,9,tick.mn=4,mx=7.5)

par(new=T)
lines(log10(alb_4hap_new$left_time_boundary),log10(alb_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[4])
par(new=T)
lines(log10(alb_8hap_new$left_time_boundary),log10(alb_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[4])

##Wisconsin
lines(log10(wil_2hap_new$left_time_boundary),log10(wil_2hap_new$lambda_00),type="s",lwd=3,lty=2,col=colors[10])

lines(log10(wil_4hap_new$left_time_boundary),log10(wil_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[10])

lines(log10(wil_8hap_new$left_time_boundary),log10(wil_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[10])

##total P.tremuloides
lines(log10(tremuloides_2hap_new$left_time_boundary),log10(tremuloides_2hap_new$lambda_00),type="s",lwd=3,lty=2,col=colors[2])

lines(log10(tremuloides_4hap_new$left_time_boundary),log10(tremuloides_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[2])

lines(log10(tremuloides_8hap_new$left_time_boundary),log10(tremuloides_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[2])
###total P.tremula
lines(log10(tremula_2hap_new$left_time_boundary),log10(tremula_2hap_new$lambda_00),type="s",lwd=3,lty=2,col=colors[6])

lines(log10(tremula_4hap_new$left_time_boundary),log10(tremula_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[6])

lines(log10(tremula_8hap_new$left_time_boundary),log10(tremula_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[6])



legend(3.8,6.4,c("2 hapl.(Alberta)","4 hapl.(Alberta)","8 hapl.(Alberta)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[4],colors[4],colors[4]),bty="n",cex=0.8)
legend(5.0,6.4,c("2 hapl.(Wisconsin)","4 hapl.(Wisconsin)","8 hapl.(Wisconsin)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[10],colors[10],colors[10]),bty="n",cex=0.8)
legend(5.0,7,c("2 hapl.(P.tremuloides)","4 hapl.(P.tremuloides)","8 hapl.(P.tremuloides)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[2],colors[2],colors[2]),bty="n",cex=0.8)
legend(3.8,7,c("2 hapl.(P.tremula)","4 hapl.(P.tremula)","8 hapl.(P.tremula)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[6],colors[6],colors[6]),bty="n",cex=0.8)


dev.off()


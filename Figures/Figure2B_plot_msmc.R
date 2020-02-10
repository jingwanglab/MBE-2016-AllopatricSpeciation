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



tremula_2hap=read.table("tremula.2hap.msmc.output.plot.txt",header=T)
tremuloides_2hap=read.table("tremuloides.2hap.msmc.output.plot.txt",header=T)
tremula_4hap=read.table("tremula.4hap.msmc.output.plot.txt",header=T)
tremuloides_4hap=read.table("tremuloides.4hap.msmc.output.plot.txt",header=T)
tremula_8hap=read.table("tremula.8hap.msmc.output.plot.txt",header=T)
tremuloides_8hap=read.table("tremuloides.8hap.msmc.output.plot.txt",header=T)

tremula_8hap_new=tremula_8hap[2:38,]
tremuloides_8hap_new=tremuloides_8hap[2:38,]
tremula_4hap_new=tremula_4hap[2:38,]
tremuloides_4hap_new=tremuloides_4hap[2:38,]
tremula_2hap_new=tremula_2hap[2:38,]
tremuloides_2hap_new=tremuloides_2hap[2:38,]


pdf("tremula_tremuloides.msmc.pdf")
par(mfrow=c(1,1))
plot(log10(tremula_2hap_new$left_time_boundary),log10(tremula_2hap_new$lambda_00),type="s",lwd=3,lty=2,xlim=c(3,6.5),ylim=c(4,7.5),col=colors[6],xaxt='n',yaxt='n',xlab="Time (years ago)",ylab="Effective population size")

axis(side=1,at=c(3,4,5,6),labels=c(expression(10^3),expression(10^4),expression(10^5),expression(10^6)))
minor.ticks.axis(1,9,tick.mn=3,mx=6.5)


axis(side=2,at=c(4,5,6,7),labels=c(expression(10^4),expression(10^5),expression(10^6),expression(10^7)))
minor.ticks.axis(2,9,tick.mn=4,mx=7.5)

par(new=T)
lines(log10(tremula_4hap_new$left_time_boundary),log10(tremula_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[6])
par(new=T)
lines(log10(tremula_8hap_new$left_time_boundary),log10(tremula_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[6])

lines(log10(tremuloides_2hap_new$left_time_boundary),log10(tremuloides_2hap_new$lambda_00),type="s",lwd=3,lty=2,col=colors[2])

lines(log10(tremuloides_4hap_new$left_time_boundary),log10(tremuloides_4hap_new$lambda_00),type="s",lwd=3,lty=3,col=colors[2])

lines(log10(tremuloides_8hap_new$left_time_boundary),log10(tremuloides_8hap_new$lambda_00),type="s",lwd=3,lty=1,col=colors[2])


legend(3.8,7,c("2 hapl.(P.tremula)","4 hapl.(P.tremula)","8 hapl.(P.tremula)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[6],colors[6],colors[6]),bty="n",cex=0.8)
legend(4.8,7,c("2 hapl.(P.tremuloides)","4 hapl.(P.tremuloides)","8 hapl.(P.tremuloides)"),lty=c(2,3,1),lwd=c(3,3,3),col=c(colors[2],colors[2],colors[2]),bty="n",cex=0.8)
dev.off()


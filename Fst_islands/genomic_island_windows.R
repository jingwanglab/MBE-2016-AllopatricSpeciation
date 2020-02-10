library(RColorBrewer)
colors <- brewer.pal(10,"Paired")[c(1,2,3,4,5,6,7,8,9,10)]
setwd("~/Dropbox/PaperII/paper/version3/data/genomic_island")

low=c(311,34,3,1)
low_high_pi=c(47,2,0,0)
high_both=c(25,2,0)
high_tremula=c(55,3,0)
high_tremuloides=c(32,5,1)
high_rest=c(299,34,4)
high=c(382,60,17,2)


label=c("0-10","10-20","20-30")
label2=c("0-10","10-20","20-30","30-40")

low_high=rbind(prop.table(low_high_pi),prop.table(high_both),prop.table(high_tremula),prop.table(high_tremuloides),prop.table(high_rest))
low_high_table=as.table(low_high)
colnames(low_high_table)=label

#rownames(low_high_table)=c("Regions under divergent selection","Regions under balancing selection")
pdf("genomic_island.region.pdf")
par(mfrow=c(1,1))
#barplot(low_high_table,ylim=c(0,1),beside=TRUE,xlab="Size of Regions (kb)",ylab="Proportion of Regions",col=c(colors[4],"black",colors[6],colors[2],"grey"),legend=rownames(low_high_table))
barplot(low_high_table,ylim=c(0,1),beside=TRUE,xlab="Size of Regions (kb)",ylab="Proportion of Regions",col=c(colors[4],"black",colors[6],colors[2],"grey"))

dev.off()

####2version, only consider the high and low Fst windows
low_high_2=rbind(prop.table(high),prop.table(low_high_pi))
low_high_table_2=as.table(low_high_2)
colnames(low_high_table_2)=label2

png("genomic_island.region.high_low.png",width=6,height=5,units='in',res=300)
par(mfrow=c(1,1))
rownames(low_high_table_2)=c("Regions under directional selection","Regions under balancing selection")
#barplot(low_high_table,ylim=c(0,1),beside=TRUE,xlab="Size of Regions (kb)",ylab="Proportion of Regions",col=c(colors[4],"black",colors[6],colors[2],"grey"),legend=rownames(low_high_table))
barplot(low_high_table_2,ylim=c(0,1),beside=TRUE,xlab="Size of Regions (kb)",ylab="Proportion",col=c(colors[8],colors[4]),legend=rownames(low_high_table_2))
dev.off()
 







summary=read.table("tremula_tremuloides.total.angsd.propor.summary",header=T)

summary$tremula_ldhat_new=summary$tremula_ldhat/1000
summary$tremuloides_ldhat_new=summary$tremuloides_ldhat/1000

summary$tremula_pi_dxy=summary$tremula_tP.norm/summary$dxy
summary$tremuloides_pi_dxy=summary$tremuloides_tP.norm/summary$dxy

install.packages("pastecs")
library(pastecs)

stat.desc(summary[,3:38])
stat=by(summary[,3:38],summary$Chr,stat.desc)
total=stat.desc(summary[,3:38])

##diversity
pi_chr1=round(stat[[1]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr2=round(stat[[2]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr3=round(stat[[3]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr4=round(stat[[4]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr5=round(stat[[5]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr6=round(stat[[6]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr7=round(stat[[7]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr8=round(stat[[8]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr9=round(stat[[9]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr10=round(stat[[10]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr11=round(stat[[11]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr12=round(stat[[12]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr13=round(stat[[13]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr14=round(stat[[14]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr15=round(stat[[15]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr16=round(stat[[16]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr17=round(stat[[17]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr18=round(stat[[18]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr19=round(stat[[19]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)
pi_chr=round(total[c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_pi_dxy")],digits=4)

pi_total=rbind(pi_chr1,pi_chr2,pi_chr3,pi_chr4,pi_chr5,pi_chr6,pi_chr7,pi_chr8,pi_chr9,pi_chr10,pi_chr11,pi_chr12,pi_chr13,pi_chr14,pi_chr15,pi_chr16,pi_chr17,pi_chr18,pi_chr19,pi_chr)


















chr1=round(stat[[1]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_pi_dxy","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")],digits=4)
chr2=stat[[2]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr3=stat[[3]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr4=stat[[4]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr5=stat[[5]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr6=stat[[6]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr7=stat[[7]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr8=stat[[8]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr9=stat[[9]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]
chr10=stat[[10]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]

chr11=stat[[11]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]

chr8=stat[[8]][c("mean","std.dev"),c("tremula_tW.norm","tremula_tP.norm","tremula_tajD","tremula_fayH","tremula_ld","tremula_ldhat_new","tremuloides_tW.norm","tremuloides_tP.norm","tremuloides_tajD","tremuloides_fayH","tremuloides_ld","tremuloides_ldhat_new","fst","fixed","dxy")]







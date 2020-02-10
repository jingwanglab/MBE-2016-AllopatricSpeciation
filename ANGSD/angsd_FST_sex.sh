#! /bin/bash -l


#set -e
#set -x


#SBATCH -A b2012199
#SBATCH -p core
#SBATCH -o angsd_FST_sex.out
#SBATCH -e angsd_FST_sex.err
#SBATCH -J angsd_FST_sex.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

#angsd="/proj/b2011141/tools/angsd0.577/angsd"
angsd="/proj/b2011141/tools/angsd0.579/angsd"
emOptim2="/proj/b2011141/tools/angsd0.579/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.579/misc/thetaStat"
bam_list_female="/proj/b2011141/nobackup/sex/asp201/bam/female/bam_list.female"
bam_list_male="/proj/b2011141/nobackup/sex/asp201/bam/male/bam_list.male"
ref="/proj/b2011141/nobackup/reference/asp201/GAM_asp201-001.scaffolds.fa"
OutDir="/proj/b2011141/nobackup/sex/asp201/ANGSD/sex_gene/Fst"
region="/proj/b2011141/nobackup/sex/asp201/ANGSD/region"

ngsFst="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsFST"

sex_gene=$region/sex_merge_gene.region

#first generate .saf file
$angsd -bam $bam_list_female -GL 1 -doSaf 1 -out $OutDir/female_sex_gene -anc $ref -fold 1 -rf $sex_gene -minMapQ 1  
$angsd -bam $bam_list_male -GL 1 -doSaf 1 -out $OutDir/male_sex_gene -anc $ref -fold 1 -rf $sex_gene -minMapQ 1  

#use emOptim2 to optimization
$emOptim2 $OutDir/female_sex_gene.saf 19 -maxIter 100 > $OutDir/female_sex_gene.saf.em.ml
$emOptim2 $OutDir/male_sex_gene.saf 19 -maxIter 100 > $OutDir/male_sex_gene.saf.em.ml

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
$ngsFst -postfiles $OutDir/female_sex_gene.saf $OutDir/male_sex_gene.saf -priorfiles $OutDir/female_sex_gene.saf.em.ml $OutDir/male_sex_gene.saf.em.ml -nind 19 19 -outfile $OutDir/female_male_gene.fst -nsites 72126 -block_size 10000 -islog 1 -isfold 1

#! /bin/bash -l


#set -e
#set -x


#SBATCH -A b2012210
#SBATCH -p core
#SBATCH -o angsd_asp201_PCA.out
#SBATCH -e angsd_asp201_PCA.err
#SBATCH -J angsd_asp201_PCA.job
#SBATCH -t 3-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.588/angsd"
emOptim2="/proj/b2011141/tools/angsd0.588/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.588/misc/thetaStat"
bam_list_pop="/proj/b2011141/nobackup/all_populations/bam/$1/$1.bamlist"
ref="/proj/b2011141/nobackup/reference/asp201/GAM_asp201-001.scaffolds.fa"
Input="/proj/b2011141/nobackup/all_populations/ANGSD/SFS/$1"
OutDir="/proj/b2011141/nobackup/all_populations/ANGSD/PCA"
#region="/proj/b2011141/nobackup/all_populations/ANGSD/region/total"
region="/proj/b2011141/nobackup/all_populations/total_bed/split"

ngsCovar="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsCovar"


#total=$region/asp201_24mul.Total.region
total=$region/$2.region


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

nInd=$(cat $bam_list_pop | wc -l)
nChrom=$(echo "2*$nInd" | bc)

#calculate posterior probabilities of sample allele frequencies
$angsd -bam $bam_list_pop -GL 1 -doSaf 1 -anc $ref -fold 1 -rf $total -minMapQ 1 -pest $Input/$1.saf.em.ml -out $OutDir/$1.$2.rf

#Use ANGSD to compute genotype posterior probabilities
#$angsd -bam $bam_list_pop -GL 1 -doGeno 32 -doPost 1 -doMaf 1 -rf $total -out $OutDir/$1 -doMajorMinor 1 -ref $ref -minMapQ 1 

#get covariance matric
#gunzip $OutDir/$1.geno.gz

#$ngsCovar -probfile $OutDir/$1.geno -outfile $OutDir/$1.covar1 -nind $nInd -call 0 -isfold 1 -sfsfile $OutDir/$1.rf.saf -norm 0 -nsites 237783558 -block_size 100000





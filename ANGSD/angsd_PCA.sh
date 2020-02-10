#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -n 1
#SBATCH -o angsd_PCA_tremula_tremuloides.out
#SBATCH -e angsd_PCA_tremula_tremuloides.err
#SBATCH -J angsd_PCA_tremula_tremuloides.job
#SBATCH -t 2-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.602/misc/thetaStat"
bam_list_all="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/all/tremula_tremuloides.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
#OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/PCA/Chr$1"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/PCA/all"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr/chr"
chr=$region/all.filter.Chr$1.region
ngsCovar="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsCovar"

nInd=$(cat $bam_list_all | wc -l)
nChrom=$(echo "2*$nInd" | bc)
#nChrom=$nInd

echo $nInd
echo $nChrom


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

#first generate .saf file
#$angsd -bam $bam_list_all -GL 1 -doSaf 1 -out $OutDir/tremula_tremuloides.Chr$1 -anc $ref -rf $chr -minMapQ 30 -minQ 20

#use emOptim2 to optimization
#$emOptim2 $OutDir/tremula_tremuloides.Chr$1.saf $nChrom -maxIter 100 -P 4 > $OutDir/tremula_tremuloides.Chr$1.sfs

#calculate posterior probabilities of sample allele frequencies
#$angsd -bam $bam_list_all -GL 1 -doSaf 1 -anc $ref -rf $chr -minMapQ 30 -minQ 20 -pest $OutDir/tremula_tremuloides.Chr$1.sfs -out $OutDir/tremula_tremuloides.Chr$1.rf

#Use ANGSD to compute genotype posterior probabilities
#$angsd -bam $bam_list_all -GL 1 -doGeno 32 -doPost 1 -doMaf 1 -rf $chr -out $OutDir/tremula_tremuloides.Chr$1 -doMajorMinor 1 -ref $ref -minMapQ 30 -minQ 20

#get covariance matric
#gunzip $OutDir/tremula_tremuloides.geno.gz

$ngsCovar -probfile $OutDir/tremula_tremuloides.all.geno -outfile $OutDir/tremula_tremuloides.all.covar1 -nind $nInd -call 0 -sfsfile $OutDir/tremula_tremuloides.all.rf.saf -norm 0 -nsites 169324638 -block_size 20000 



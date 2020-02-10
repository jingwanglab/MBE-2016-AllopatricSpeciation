#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o angsd_PCA_tremula_tremuloides.out
#SBATCH -e angsd_PCA_tremula_tremuloides.err
#SBATCH -J angsd_PCA_tremula_tremuloides.job
#SBATCH -t 5-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
bam_list_all="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/all/tremula_tremuloides.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/PCA"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr.region

nInd=$(cat $bam_list_all | wc -l)
#nChrom=$(echo "2*$nInd" | bc)
nChrom=$nInd

echo $nInd
echo $nChrom


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi


#Use ANGSD to compute genotype posterior probabilities
$angsd -bam $bam_list_all -GL 1 -doGeno 32 -doPost 1 -doMaf 1 -rf $chr -out $OutDir/tremula_tremuloides -doMajorMinor 1 -ref $ref -minMapQ 30 -minQ 20

#get covariance matric
gunzip $OutDir/tremula_tremuloides.geno.gz

$ngsCovar -probfile $OutDir/tremula_tremuloides.geno -outfile $OutDir/tremula_tremuloides.covar1 -nind $nInd -call 1 -norm 1 -nsites 100000000 -block_size 20000 -minmaf 0.05



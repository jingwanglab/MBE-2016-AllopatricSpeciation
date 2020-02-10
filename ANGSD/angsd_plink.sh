#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o angsd_plink.out
#SBATCH -e angsd_plink.err
#SBATCH -J angsd_plink.job
#SBATCH -t 12:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
bam_list_all="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/all/tremula_tremuloides.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/plink/all/Chr$1"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi


#first generate .plink file
$angsd -bam $bam_list_all -GL 1 -doMajorMinor 1 -doMaf 2 -doPlink 2 -doGeno -4 -doPost 1 -postCutoff 0.99 -SNP_pval 1e-6 -geno_minDepth 4 -out $OutDir/tremula_tremuloides.$1 -ref $ref -rf $chr -minMapQ 30 -minQ 20 -doCounts 1 



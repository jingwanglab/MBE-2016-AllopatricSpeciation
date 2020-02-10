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
bam_list_tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremula/tremula.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/ancestral_major/plink/tremula/Chr$1"
#OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/plink/tremula/Chr$1"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi


#first generate .plink file
#$angsd -bam $bam_list_tremula -GL 1 -doMajorMinor 1 -doMaf 2 -doPlink 2 -doGeno -4 -doPost 1 -postCutoff 0.99 -SNP_pval 1e-6 -geno_minDepth 4 -out $OutDir/tremula.chr$1 -ref $ref -rf $chr -minMapQ 30 -minQ 20 -doCounts 1 

#generate plink file and genotype file, coded as -1,0,1,2 and also show ancestral and derived alleles
$angsd -bam $bam_list_tremula -GL 1 -doMajorMinor 5 -anc $ref -doMaf 2 -doPlink 2 -doGeno 5 -doPost 1 -postCutoff 0.99 -SNP_pval 1e-6 -geno_minDepth 4 -out $OutDir/tremula.chr$1 -ref $ref -rf $chr -minMapQ 30 -minQ 20 -doCounts 1 



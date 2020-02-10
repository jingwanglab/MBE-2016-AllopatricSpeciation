#! /bin/bash -l


#set -e
#set -x


#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o angsd_MAF_tremuloides.out
#SBATCH -e angsd_MAF_tremuloides.err
#SBATCH -J angsd_MAF_tremuloides.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL


angsd="/proj/b2011141/tools/angsd0.602/angsd"
bam_list_tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremuloides/tremuloides.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/MAF/tremuloides/Chr$1"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi


$angsd -bam $bam_list_tremuloides -GL 1 -doMajorMinor 1 -doMaf 1 -ref $ref -out $OutDir/tremuloides_chr$1.maf -minMapQ 30 -minQ 20 -rf $chr


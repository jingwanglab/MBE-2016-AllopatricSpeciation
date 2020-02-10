#! /bin/bash -l

#SBATCH -A b2012210
#SBATCH -p core
#SBATCH -o angsd_SFS_samtools_24tremuloides.wil.out
#SBATCH -e angsd_SFS_samtools_24tremuloides.wil.err
#SBATCH -J angsd_SFS_samtools_24tremuloides.wil.job
#SBATCH -t 6-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.902/angsd/angsd"
realSFS="/proj/b2011141/tools/angsd0.902/angsd/misc/realSFS"
thetaStat="/proj/b2011141/tools/angsd0.902/angsd/misc/thetaStat"

bam_list_tremuloides_wil="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremuloides/tremuloides.wil.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_sub/wil"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr/chr"
chr=$region/all.filter.Chr.sort.bed

nInd=$(cat $bam_list_tremuloides_wil | wc -l)
nChrom=$(echo "2*$nInd" | bc)
#nChrom=$nInd

echo $nInd
echo $nChrom


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

#first generate .saf file
$angsd -b $bam_list_tremuloides_wil -GL 1 -doSaf 1 -out $OutDir/tremuloides_wil -anc $ref -rf $chr -minMapQ 30 -minQ 20

#use emOptim2 to optimization
$realSFS $OutDir/tremuloides_wil.saf.idx $nChrom > $OutDir/tremuloides.wil.sfs



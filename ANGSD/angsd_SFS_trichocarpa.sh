#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o angsd_unfoldedSFS_samtools_24tremula.out
#SBATCH -e angsd_unfoldedSFS_samtools_24tremula.err
#SBATCH -J angsd_unfoldedSFS_samtools_24tremula.job
#SBATCH -t 24:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.602/misc/thetaStat"
bam_list_tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremula/tremula.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region

nInd=$(cat $bam_list_tremula | wc -l)
nChrom=$(echo "2*$nInd" | bc)
#nChrom=$nInd

echo $nInd
echo $nChrom


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

#first generate .saf file
#$angsd -bam $bam_list_tremula -minMapQ 30 -minQ 20 -GL 1 -doSaf 1 -out $OutDir/tremula_$1 -anc $ref -rf $chr

#use emOptim2 to optimization
#$emOptim2 $OutDir/tremula_$1.saf $nChrom -maxIter 100 -P 4 > $OutDir/tremula_$1.sfs

#calculate thetas
#$angsd -bam $bam_list_tremula -out $OutDir/tremula_$1 -doThetas 1 -GL 1 -doSaf 1 -anc $ref -rf $chr -pest $OutDir/tremula_$1.sfs -minMapQ 30 -minQ 20

#calculate Tajimas
#$thetaStat make_bed $OutDir/tremula_$1.thetas.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom
$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 5000 -step 5000 -outnames $OutDir/tremula_$1.thetas5kbwindow.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 10000 -step 10000 -outnames $OutDir/tremula_$1.thetas10kbwindow.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 100000 -step 100000 -outnames $OutDir/tremula_$1.thetas100kbwindow.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 500000 -step 500000 -outnames $OutDir/tremula_$1.thetas500kbwindow.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 10000 -step 5000 -outnames $OutDir/tremula_$1.thetas10kbwindow.5kbsliding.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 100000 -step 10000 -outnames $OutDir/tremula_$1.thetas100kbwindow.10kbsliding.gz
#$thetaStat do_stat $OutDir/tremula_$1.thetas.gz -nChr $nChrom -win 500000 -step 50000 -outnames $OutDir/tremula_$1.thetas500kbwindow.50kbsliding.gz

#calculate posterior probabilities of sample allele frequencies
#$angsd -bam $bam_list_tremula -GL 1 -doSaf 1 -anc $ref -rf $chr -minMapQ 30 -minQ 20 -pest $OutDir/tremula_$1.sfs -out $OutDir/tremula_$1.rf



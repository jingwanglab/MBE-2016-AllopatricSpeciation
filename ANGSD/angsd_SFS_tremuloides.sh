#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o angsd_SFS_samtools_24tremuloides.out
#SBATCH -e angsd_SFS_samtools_24tremuloides.err
#SBATCH -J angsd_SFS_samtools_24tremuloides.job
#SBATCH -t 24:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.602/misc/thetaStat"
bam_list_tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremuloides/tremuloides.bam.list"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
OutDir1="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1"
OutDir="/proj/b2010014/GenomePaper/population_genetics/pan_genome/ANGSD/tremuloides/tremuloides_$1"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region

nInd=$(cat $bam_list_tremuloides | wc -l)
#nChrom=$(echo "2*$nInd" | bc)
nChrom=44
#nChrom=$nInd

echo $nInd
echo $nChrom


if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

#first generate .saf file
#$angsd -bam $bam_list_tremuloides -GL 1 -doSaf 1 -out $OutDir/tremuloides_$1 -anc $ref -rf $chr -minMapQ 30 -minQ 20

#use emOptim2 to optimization
#$emOptim2 $OutDir/tremuloides_$1.saf $nChrom -maxIter 100 -P 4 > $OutDir/tremuloides_$1.sfs

#calculate thetas
#$angsd -bam $bam_list_tremuloides -out $OutDir/tremuloides_$1 -doThetas 1 -GL 1 -doSaf 1 -anc $ref -rf $chr -pest $OutDir/tremuloides_$1.sfs -minMapQ 30 -minQ 20

#calculate Tajimas
#$thetaStat make_bed $OutDir/tremuloides_$1.thetas.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 5000 -step 5000 -outnames $OutDir/tremuloides_$1.thetas5kbwindow.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 10000 -step 10000 -outnames $OutDir/tremuloides_$1.thetas10kbwindow.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 100000 -step 100000 -outnames $OutDir/tremuloides_$1.thetas100kbwindow.gz
$thetaStat do_stat $OutDir1/tremuloides_$1.thetas.gz -nChr $nChrom -win 500000 -step 500000 -outnames $OutDir/tremuloides_$1.thetas500kbwindow.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 1000000 -step 1000000 -outnames $OutDir/tremuloides_$1.thetas1Mwindow.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 10000 -step 5000 -outnames $OutDir/tremuloides_$1.thetas10kbwindow.5kbsliding.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 100000 -step 10000 -outnames $OutDir/tremuloides_$1.thetas100kbwindow.10kbsliding.gz
#$thetaStat do_stat $OutDir/tremuloides_$1.thetas.gz -nChr $nChrom -win 500000 -step 50000 -outnames $OutDir/tremuloides_$1.thetas500kbwindow.50kbsliding.gz

#calculate posterior probabilities of sample allele frequencies
#$angsd -bam $bam_list_tremuloides -GL 1 -doSaf 1 -anc $ref -rf $chr -minMapQ 30 -minQ 20 -pest $OutDir/tremuloides_$1.sfs -out $OutDir/tremuloides_$1.rf


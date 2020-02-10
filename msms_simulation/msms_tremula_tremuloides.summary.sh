#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o msms_two_aspens.out
#SBATCH -e msms_two_aspens.err
#SBATCH -J msms_two_aspens.job
#SBATCH -t 24:00:00

module load bioinfo-tools
module load java

msms="/proj/b2011141/tools/msms/msms3.2rc-b163.jar"
ref="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa.fai"
anc="/proj/b2011141/nobackup/reference/nisqV3/Ptrichocarpa_v3.0_210.fa"
msToGlf="/proj/b2011141/tools/angsd0.902/angsd/misc/msToGlf"
splitgl="/proj/b2011141/tools/angsd0.902/angsd/misc/splitgl"
realSFS="/proj/b2011141/tools/angsd0.902/angsd/misc/realSFS"
emOptim2="/proj/b2011141/tools/angsd0.902/angsd/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.902/angsd/misc/thetaStat"
angsd="/proj/b2011141/tools/angsd0.902/angsd/angsd"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/msms/run$1"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

###the demographic model was the model detected by fastsimcoal2.5 with the largest maximum likelihood (model 17_2, and the best run is run49)
###here is the location of the best model, with parameters needed for this simulation /proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/fastsimcoal2/model17_2/run49/model17

###From the model, N0=N_tremula=102814, theta=4*102814*3.75*10-8=0.0154221, 
###Time of divergence of P.tremula and P.tremuloides, T=155494 generations, t=155494/4*102814=0.3781
###N_tremuloides=309500,exponential growth rate=log(56235/309500)/0.3781
###

###1.the simulation is based for 10kb sites
java -jar $msms -ms 92 1 -t 154 -r 32.3 -I 2 48 44 -n 1 1 -n 2 3.01 -g 2 4.5105 -ma x 0.1 0.4 x -ej 0.3781 2 1 > $OutDir/msms_run$1.output
###2. run mstoglf 
$msToGlf -in $OutDir/msms_run$1.output -nind 46 -out $OutDir/msms_run$1.output -regLen 20000 -singleOut 1 -depth 20 -err 0.005
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 20000 -singleOut 1 -depth 20 -err 0.005
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 10000 -singleOut 1 -depth 20
###3.slice out the two species into separate files
$splitgl $OutDir/msms_run$1.output.glf.gz 92 1 48 > $OutDir/tremula.glf.gz
$splitgl $OutDir/msms_run$1.output.glf.gz 92 49 92 > $OutDir/tremuloides.glf.gz
###4. run -doSaf 1 on both files
$angsd -glf $OutDir/tremula.glf.gz -nInd 48 -doSaf 1 -out $OutDir/tremula -fai $ref -isSim 1
$angsd -glf $OutDir/tremuloides.glf.gz -nInd 44 -doSaf 1 -out $OutDir/tremuloides -fai $ref -isSim 1
###4. 1dsfs and 2dsfs
$realSFS $OutDir/tremula.saf.idx > $OutDir/tremula.sfs
$realSFS $OutDir/tremuloides.saf.idx > $OutDir/tremuloides.sfs
$realSFS $OutDir/tremula.saf.idx $OutDir/tremuloides.saf.idx > $OutDir/tremula.tremuloides.ml
###5. fst for easy window analysis
$realSFS fst index $OutDir/tremula.saf.idx $OutDir/tremuloides.saf.idx -sfs $OutDir/tremula.tremuloides.ml -fstout $OutDir/tremula.tremuloides.run$1
###6. get the global estimate of fst
$realSFS fst stats $OutDir/tremula.tremuloides.run$1.fst.idx > $OutDir/tremula.tremuloides.run$1.global.fst
###7. window-based analysis for fst
#$realSFS fst stats2 $OutDir/tremula.tremuloides.run$1.fst.idx -win 10000 -step 10000 > $OutDir/tremula.tremuloides.run$1.10kbwindow.fst
###8. estimate the thetas and neutral tests separately for the two speceis
$angsd -glf $OutDir/tremula.glf.gz -nInd 48 -doSaf 1 -doThetas 1 -anc $anc -fai $ref -pest $OutDir/tremula.sfs -out $OutDir/tremula
$angsd -glf $OutDir/tremuloides.glf.gz -nInd 44 -doSaf 1 -doThetas 1 -anc $anc -fai $ref -pest $OutDir/tremuloides.sfs -out $OutDir/tremuloides

$thetaStat make_bed $OutDir/tremula.thetas.gz
$thetaStat do_stat $OutDir/tremula.thetas.gz -nChr 48 
$thetaStat do_stat $OutDir/tremula.thetas.gz -nChr 48 -win 10000 -step 10000 -outnames $OutDir/tremula.thetas10kb.gz

$thetaStat make_bed $OutDir/tremuloides.thetas.gz
$thetaStat do_stat $OutDir/tremuloides.thetas.gz -nChr 44
$thetaStat do_stat $OutDir/tremuloides.thetas.gz -nChr 44 -win 10000 -step 10000 -outnames $OutDir/tremuloides.thetas10kb.gz

rm $OutDir/*gz
rm $OutDir/*output
rm $OutDir/*argg
rm $OutDir/*pgEstH
rm $OutDir/*vPos
rm $OutDir/*arg
rm $OutDir/*idx
rm $OutDir/*ml



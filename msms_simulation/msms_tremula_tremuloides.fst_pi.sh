#! /bin/bash -l

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o msms_two_aspens.out
#SBATCH -e msms_two_aspens.err
#SBATCH -J msms_two_aspens.job
#SBATCH -t 18:00:00

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
### assume the exponantao rate of tremula is log(56235/

#1.define the recombination rate 
n_tremula=$(shuf -i 1000-5000 -n 1)
echo $n_tremula
###recombination for the input of msms
recombination=$(echo "scale=4;$n_tremula/100" |bc)
echo $recombination

for file in {1..1000}
do
###1.the simulation is based for 10kb sites
#java -jar $msms -ms 46 1 -t 154 -r 32.3 -I 2 24 22 -n 2 3.01 -g 2 4.5105 -ma x 0.1 0.4 x -ej 0.3781 2 1 > $OutDir/msms_run$1.$file.output
java -jar $msms -ms 92 1 -t 290 -r $recombination -I 2 48 44 -n 2 3.01 -g 2 4.5105 -ma x 0.1 0.4 x -ej 0.51 2 1 -en 0.51 1 0.5469 > $OutDir/msms_run$1.$file.output
###2. run mstoglf 
$msToGlf -in $OutDir/msms_run$1.$file.output -nind 46 -out $OutDir/msms_run$1.$file.output -regLen 10000 -singleOut 1 -depth 20 -err 0.005 
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 20000 -singleOut 1 -depth 20 -err 0.005
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 10000 -singleOut 1 -depth 20
###3.slice out the two species into separate files
$splitgl $OutDir/msms_run$1.$file.output.glf.gz 46 1 24 > $OutDir/tremula.$file.glf.gz
$splitgl $OutDir/msms_run$1.$file.output.glf.gz 46 25 46 > $OutDir/tremuloides.$file.glf.gz
###4. run -doSaf 1 on both files
$angsd -glf $OutDir/tremula.$file.glf.gz -nInd 24 -doSaf 1 -out $OutDir/tremula.$file -fai $ref -isSim 1 
$angsd -glf $OutDir/tremuloides.$file.glf.gz -nInd 22 -doSaf 1 -out $OutDir/tremuloides.$file -fai $ref -isSim 1 
###4. 1dsfs and 2dsfs
$realSFS $OutDir/tremula.$file.saf.idx > $OutDir/tremula.$file.sfs
$realSFS $OutDir/tremuloides.$file.saf.idx > $OutDir/tremuloides.$file.sfs
$realSFS $OutDir/tremula.$file.saf.idx $OutDir/tremuloides.$file.saf.idx > $OutDir/tremula.tremuloides.$file.ml
###5. fst for easy window analysis
$realSFS fst index $OutDir/tremula.$file.saf.idx $OutDir/tremuloides.$file.saf.idx -sfs $OutDir/tremula.tremuloides.$file.ml -fstout $OutDir/tremula.tremuloides.run$1.$file
###6. get the global estimate of fst
$realSFS fst stats $OutDir/tremula.tremuloides.run$1.$file.fst.idx >> $OutDir/tremula.tremuloides.run$1.global.fst
###pi and Tajima's D
$angsd -glf $OutDir/tremula.$file.glf.gz -nInd 24 -doSaf 1 -doThetas 1 -anc $anc -fai $ref -pest $OutDir/tremula.$file.sfs -out $OutDir/tremula.$file -isSim 1
$angsd -glf $OutDir/tremuloides.$file.glf.gz -nInd 22 -doSaf 1 -doThetas 1 -anc $anc -fai $ref -pest $OutDir/tremuloides.$file.sfs -out $OutDir/tremuloides.$file -isSim 1

$thetaStat make_bed $OutDir/tremula.$file.thetas.gz
$thetaStat do_stat $OutDir/tremula.$file.thetas.gz -nChr 24

$thetaStat make_bed $OutDir/tremuloides.$file.thetas.gz
$thetaStat do_stat $OutDir/tremuloides.$file.thetas.gz -nChr 22


rm $OutDir/*gz
rm $OutDir/*output
rm $OutDir/*argg
rm $OutDir/*pgEstH
rm $OutDir/*vPos
rm $OutDir/*arg
rm $OutDir/*idx
rm $OutDir/*ml
rm $OutDir/*sfs
rm $OutDir/*bin

done


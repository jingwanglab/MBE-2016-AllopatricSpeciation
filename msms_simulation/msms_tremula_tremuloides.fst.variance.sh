#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o msms_two_aspens.out
#SBATCH -e msms_two_aspens.err
#SBATCH -J msms_two_aspens.job
#SBATCH -t 12:00:00

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
###However, one problem is that the fst values estimated here is always have smaller variance than the real data, therefore, I used the parameters from 95% confidenceintervals to simulate the fst values from the data.

#1.define the effective population size of tremula
n_tremula=$(shuf -i 93688-105671 -n 1)
###theta for the input of msms
theta=$(echo "scale=4;10000*4*$n_tremula*3.75*0.00000001" |bc)
echo $theta
###the Ne for P.tremuloides
n_tremuloides=$(shuf -i 247321-310105 -n 1)
n_tremuloides_tremula=$(echo "scale=4;$n_tremuloides/$n_tremula" |bc)
echo $n_tremuloides_tremula
t=$(shuf -i 145784-207568 -n 1)

##divergence time transfer
div_t=$(echo "scale=4;$t/(4*$n_tremula)" |bc)
echo $div_t

###ancestral effective population size
n_ancestal=$(shuf -i 48012-69492 -n 1)
###growth rate
grow=$(perl -E "say -log($n_ancestal/$n_tremuloides)/$div_t")
echo $grow
##migration from tremula to tremuloides
mig1_2=$(shuf -i 0.052-0.117 -n 1)
n_mig1_2=$(echo "2*$mig1_2"|bc)
echo $n_mig1_2
##migration from tremuloides to tremula
mig2_1=$(shuf -i 0.156-0.375 -n 1)
n_mig2_1=$(echo "2*$mig2_1"|bc)
echo $n_mig2_1

for file in {1..100}
do
###1.the simulation is based for 10kb sites
java -jar $msms -ms 92 1 -t $theta -r 32.3 -I 2 48 44 -n 1 1 -n 2 $n_tremuloides_tremula -g 2 $grow -ma x 0.1 0.4 x -ej $div_t 2 1 > $OutDir/msms_run$1.$file.output
###2. run mstoglf 
$msToGlf -in $OutDir/msms_run$1.$file.output -nind 46 -out $OutDir/msms_run$1.$file.output -regLen 20000 -singleOut 1 -depth 20 -err 0.005
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 20000 -singleOut 1 -depth 20 -err 0.005
#$msToGlf -in $OutDir/msms_run$1.output -out $OutDir/msms_run$1.output -regLen 10000 -singleOut 1 -depth 20
###3.slice out the two species into separate files
$splitgl $OutDir/msms_run$1.$file.output.glf.gz 92 1 48 > $OutDir/tremula.$file.glf.gz
$splitgl $OutDir/msms_run$1.$file.output.glf.gz 92 49 92 > $OutDir/tremuloides.$file.glf.gz
###4. run -doSaf 1 on both files
$angsd -glf $OutDir/tremula.$file.glf.gz -nInd 48 -doSaf 1 -out $OutDir/tremula.$file -fai $ref -isSim 1
$angsd -glf $OutDir/tremuloides.$file.glf.gz -nInd 44 -doSaf 1 -out $OutDir/tremuloides.$file -fai $ref -isSim 1
###4. 1dsfs and 2dsfs
$realSFS $OutDir/tremula.$file.saf.idx $OutDir/tremuloides.$file.saf.idx > $OutDir/tremula.tremuloides.$file.ml
###5. fst for easy window analysis
$realSFS fst index $OutDir/tremula.$file.saf.idx $OutDir/tremuloides.$file.saf.idx -sfs $OutDir/tremula.tremuloides.$file.ml -fstout $OutDir/tremula.tremuloides.run$1.$file
###6. get the global estimate of fst
$realSFS fst stats $OutDir/tremula.tremuloides.run$1.$file.fst.idx >> $OutDir/tremula.tremuloides.run$1.global.fst

rm $OutDir/*gz
rm $OutDir/*output
rm $OutDir/*argg
rm $OutDir/*pgEstH
rm $OutDir/*vPos
rm $OutDir/*arg
rm $OutDir/*idx
rm $OutDir/*ml

done


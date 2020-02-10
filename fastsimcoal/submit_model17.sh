#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -n 4
#SBATCH -o fsc25.model17_2.out
#SBATCH -e fsc25.model17_2.err
#SBATCH -J fsc25.model17_2.job
#SBATCH -t 6-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

fsc251="/proj/b2011141/tools/fsc_linux64-2/fsc251"
rep=$1
bootstrap="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/fastsimcoal2/bootstrap/rep$1"
sum_matrix="/proj/b2011141/pipeline/R/fastsimcoal2/sum_matrix.table.R"
header="/proj/b2011141/pipeline/fastsimcoal2/model17_bootstrap/header"
col="/proj/b2011141/pipeline/fastsimcoal2/model17_bootstrap/col"
est="/proj/b2011141/pipeline/fastsimcoal2/model17_bootstrap/model17.est"
tpl="/proj/b2011141/pipeline/fastsimcoal2/model17_bootstrap/model17.tpl"


$fsc251 -i $bootstrap/model17_maxL.par -n805 -d -s0 -k100000 
i=49
sed '1,2d' $bootstrap/model17_maxL/model17_maxL_jointDAFpop1_0.obs |cut -f 2-46 > $bootstrap/model17_maxL/try

for file in {1..805}
do
head -$i $bootstrap/model17_maxL/try > $bootstrap/model17_maxL/try$file
sed '1,49d' $bootstrap/model17_maxL/try > $bootstrap/model17_maxL/temp && mv $bootstrap/model17_maxL/temp $bootstrap/model17_maxL/try
done
cp $bootstrap/model17_maxL/try1 $bootstrap/model17_maxL/sum_all

for file2 in {2..805}
do
Rscript $sum_matrix $bootstrap/model17_maxL $bootstrap/model17_maxL/sum_all $bootstrap/model17_maxL/try$file2
done

rm $bootstrap/model17_maxL/try*
paste $col $bootstrap/model17_maxL/sum_all > $bootstrap/model17_maxL/temp && mv $bootstrap/model17_maxL/temp $bootstrap/model17_maxL/sum_all
cat $header $bootstrap/model17_maxL/sum_all > $bootstrap/model17_maxL/model17_jointDAFpop1_0.obs

cp $est $tpl $bootstrap/model17_maxL/

for n in {1..50}
do

run=$bootstrap/model17_maxL/run$n

if [ ! -d "$run" ]; then
mkdir -p $run
fi

$fsc251 -t $bootstrap/model17_maxL/model17.tpl -n100000 -N100000 -d -e $bootstrap/model17_maxL/model17.est -M 1e-5 -w 1e-5 -l 10 -L 40 -q -c 4 -B 32

`cp -r $bootstrap/model17_maxL/model17/ $run`

done


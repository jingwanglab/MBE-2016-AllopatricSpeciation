#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -n 4
#SBATCH -o fsc25.model17_2.out
#SBATCH -e fsc25.model17_2.err
#SBATCH -J fsc25.model17_2.job
#SBATCH -t 9-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

fsc25="/proj/b2011141/tools/fsc_linux64/fsc25"
model17_2="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/fastsimcoal2/model17_2"
directory=`pwd`

if [ ! -d "$model17_2" ]; then
mkdir -p $model17_2
fi

for n in {1..100}
do

run=$model17_2/run$n

if [ ! -d "$run" ]; then
mkdir -p $run
fi

$fsc25 -t model17.tpl -n100000 -N100000 -d -e model17.est -M 1e-5 -w 1e-5 -l 10 -L 40 -q -c 4 -B 32

`cp -r $directory/model17/ $run`

done



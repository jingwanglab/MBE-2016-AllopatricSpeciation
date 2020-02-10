#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o fcgene_to_fastphase.out
#SBATCH -e fcgene_to_fastphase.err
#SBATCH -J fcgene_to_fastphase.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

fcgene="/proj/b2011141/tools/fcgene-1.0.7/fcgene"
ped=$1
map=$2

OutDir=`dirname $1`
Out=${1##*/}
OutSuffix=${Out%.ped}

fastphase=$OutDir/fastphase

if [ ! -d "$fastphase" ]; then
mkdir -p $fastphase
fi

$fcgene --ped $ped --map $map --oformat phase --out $fastphase/$OutSuffix 



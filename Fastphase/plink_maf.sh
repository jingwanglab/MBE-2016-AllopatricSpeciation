#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o plink_maf.out
#SBATCH -e plink_maf.err
#SBATCH -J plink_maf.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

plink="/proj/b2011141/tools/plink_1.9/plink"
ped=$1
map=$2

OutDir=`dirname $1`
Out=${1##*/}

rm_fixed=$OutDir/rm_fixed

if [ ! -d "$rm_fixed" ]; then
mkdir -p $rm_fixed
fi

$plink --ped $ped --map $map --out $rm_fixed/$Out --maf 0.001 --recode






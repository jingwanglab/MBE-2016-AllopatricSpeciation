#! /bin/bash -l

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o plink_extract.out
#SBATCH -e plink_extract.err
#SBATCH -J plink_extract.job
#SBATCH -t 6:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

plink="/proj/b2011141/tools/plink_1.9/plink"
ped=$1
map=$2

OutDir=`dirname $1`
Out=${1##*/}
OutSuffix=${Out%.ped}

for file in $OutDir/chr*snp
do
input=${file##*/}
n=${input%.*}
number=${n##*.}
$plink --ped $ped --map $map --extract $file --out $OutDir/$OutSuffix.$number --recode
done




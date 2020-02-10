#! /bin/bash -l


set +e
set -x

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o chr.divided.snp.out
#SBATCH -e chr.divided.snp.err
#SBATCH -J chr.divided.snp.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL


map=$1

OutDir=`dirname $1`
Out=${1##*ped.}
chr=${Out%%.map}
echo $chr


line=$(cat $map | wc -l)
echo $line
n=$(echo "$line/100000" | bc)
echo $n
final_n=$(echo "$n+1" | bc)
echo $final_n

for ((i=1;i<=$final_n;i++))
do
if [ $i -lt $n ] || [ $i -eq $n ]
then
head -n $i"00000" $map |tail -n 100000 | cut -f 2 > $OutDir/chr$chr.$i.snp
else
last_n=$(echo "$line-$n"00000"" | bc)
echo $last_n
head -n $line $map | tail -n $last_n | cut -f 2 > $OutDir/chr$chr.$i.snp
fi
done



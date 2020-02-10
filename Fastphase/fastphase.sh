#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o fastphase.out
#SBATCH -e fastphase.err
#SBATCH -J fastphase.job
#SBATCH -t 18:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

module load bioinfo-tools
module load fastPHASE

inp=$1

OutDir=`dirname $1`
Out=${1##*/}

phase=$OutDir/phasing

if [ ! -d "$phase" ]; then
mkdir -p $phase
fi

Input=${Out%.inp}

fastPHASE -o$phase/$Input -Ku12 -Kl2 -Ki2 $inp


#!/bin/bash -l

#SBATCH -A b2012141
#SBATCH -p core -n 1
#SBATCH -o msmc.tremula.h2.out
#SBATCH -e msmc.tremula.h2.err
#SBATCH -J msmc.tremula.h2.job
#SBATCH -t 05:00:00
#SBATCH --mail-user par.ingvarsson@umu.se
#SBATCH --mail-type=ALL

if [[ $# -eq 0 ]];then
    echo "No argument supplied" && exit 1
fi

module load bioinfo-tools
module load msmc/2014-09-29



OutDir="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$1"

Input=
for file in {01..19}
do
 file=/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$1/Chr$file/SwAsp.hap$1.Chr$file.msmc.final.input
 Input="$Input $file"
done

msmc --fixedRecombination -o $OutDir/new_tremula_hap$1_msmc.output $Input



#! /bin/bash -l

#SBATCH -A b2012141
#SBATCH -p core
#SBATCH -o Vcf_indiv.out
#SBATCH -e Vcf_indiv.err
#SBATCH -J Vcf_indiv.job
#SBATCH -t 6:00:00

## 1. extract the SNPs for the 2hap(1 ind), 4hap(2ind), 8hap(4ind) fro samples from a single SwAsp population
module load bioinfo-tools
module load BEDTools/2.16.2

vcf_script="/proj/b2011141/pipeline/msmc/new_trem/vcf_ind_tremula.sh"
for hap in {2,4,8}
do
    for file in Chr{01..19}
    do
        sbatch $vcf_script $file $hap
    done
done

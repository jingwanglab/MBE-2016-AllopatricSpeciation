#! /bin/bash -l

#SBATCH -A b2011141
#SBATCH -n 2
#SBATCH -o angsd_fst_stat_win.out
#SBATCH -e angsd_fst_stat_win.err
#SBATCH -J angsd_fst_stat_win.job
#SBATCH -t 24:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL


module load bioinfo-tools
module load R/3.0.1

input="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/summary/Fst/Chr$1/alb_wil"
window=$2
step=$3


Rscript angsd_fst_stat_win.R $input $1 $window $step








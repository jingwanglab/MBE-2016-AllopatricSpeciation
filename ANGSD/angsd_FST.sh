#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o angsd_FST_tremula_vs_tremuloides.out
#SBATCH -e angsd_FST_tremula_vs_tremuloides.err
#SBATCH -J angsd_FST_tremula_vs_tremuloides.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
thetaStat="/proj/b2011141/tools/angsd0.602/misc/thetaStat"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/Fst/Chr$1"

tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1"
tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1"

tremula_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.pos"

ngsFst="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsFST"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

nsites=$(cat $tremula_fix_pos | wc -l)

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
$ngsFst -postfiles $tremula/tremula_$1.rf.fix.saf $tremuloides/tremuloides_$1.rf.fix.saf -priorfiles $tremula/tremula_$1.sfs $tremuloides/tremuloides_$1.sfs -nind 24 22 -outfile $OutDir/tremula_tremuloides.chr$1.fst -nsites $nsites -block_size 20000 -islog 1



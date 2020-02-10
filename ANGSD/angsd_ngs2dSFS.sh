#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o angsd_ngs2dSFS.out
#SBATCH -e angsd_ngs2dSFS.err
#SBATCH -J angsd_ngs2dSFS.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/ngs2dSFS"

tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_all/tremula_all.rf.fix.saf"
tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_all/tremuloides_all.rf.fix.saf"

tremula_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_all/tremula_all.rf.pos"

ngs2dSFS="/proj/b2011141/tools/ngsTools/ngsPopGen/ngs2dSFS"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

nsites=$(cat $tremula_fix_pos | wc -l)

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
$ngs2dSFS -postfiles $tremula $tremuloides -relative 1 -nind 24 22 -outfile $OutDir/tremula_tremuloides.all.2dsfs -nsites $nsites -block_size 20000 



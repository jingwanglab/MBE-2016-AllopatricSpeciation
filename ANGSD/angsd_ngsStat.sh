#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2010014
#SBATCH -p core
#SBATCH -o angsd_ngsstat_tremula_vs_tremuloides.out
#SBATCH -e angsd_ngsstat_tremula_vs_tremuloides.err
#SBATCH -J angsd_ngsstat_tremula_vs_tremuloides.job
#SBATCH -t 12:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/ngsStat/Chr$1"

tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1"
tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1"

tremula_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.pos"

ngsStat="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsStat"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

nsites=$(cat $tremula_fix_pos | wc -l)

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
#$ngsStat -npop 2 -postfiles $tremula/tremula_$1.rf.fix.saf $tremuloides/tremuloides_$1.rf.fix.saf -nind 24 22 -iswin 1 -outfile $OutDir/tremula_tremuloides.chr$1.stat -nsites $nsites -block_size 1000 -islog 1 -verbose 0
$ngsStat -npop 2 -postfiles $tremula/tremula_$1.rf.fix.saf $tremuloides/tremuloides_$1.rf.fix.saf -nind 24 22 -iswin 0 -outfile $OutDir/tremula_tremuloides.chr$1.stat -nsites $nsites -block_size 10000 -islog 1 -verbose 0



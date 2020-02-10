#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o angsd_ngsstat_alb_vs_wil.out
#SBATCH -e angsd_ngsstat_alb_vs_wil.err
#SBATCH -J angsd_ngsstat_alb_vs_wil.job
#SBATCH -t 12:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
OutDir="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/ngsStat/Chr$1/alb_wil"

alb="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb"
wil="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil"

alb_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.pos"

ngsStat="/proj/b2011141/tools/ngsTools/ngsPopGen/ngsStat"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

nsites=$(cat $alb_fix_pos | wc -l)

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
#$ngsStat -npop 2 -postfiles $tremula/tremula_$1.rf.fix.saf $tremuloides/tremuloides_$1.rf.fix.saf -nind 24 22 -iswin 1 -outfile $OutDir/tremula_tremuloides.chr$1.stat -nsites $nsites -block_size 1000 -islog 1 -verbose 0
$ngsStat -npop 2 -postfiles $alb/tremuloides_$1.rf.fix.saf $wil/tremuloides_$1.rf.fix.saf -nind 12 10 -iswin 0 -outfile $OutDir/alb_wil.chr$1.stat -nsites $nsites -block_size 10000 -islog 1 -verbose 0



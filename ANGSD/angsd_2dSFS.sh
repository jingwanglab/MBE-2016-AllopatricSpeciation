#! /bin/bash -l

#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o angsd_2dsfs.out
#SBATCH -e angsd_2dsfs.err
#SBATCH -J angsd_2dsfs.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

angsd="/proj/b2011141/tools/angsd0.602/angsd"
emOptim2="/proj/b2011141/tools/angsd0.602/misc/emOptim2"
region="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bed/all/Chr"
chr=$region/all.filter.Chr$1.region
bam_list_tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremula/tremula.bam.list"
bam_list_tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/bam/tremuloides/tremuloides.bam.list"

tremula="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1"
tremuloides="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1"

tremula_rf_saf_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.saf.pos"
tremuloides_rf_saf_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.saf.pos"

intersect="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/intersect.txt"

#produce intersect.txt
#cat $tremula_rf_saf_pos $tremuloides_rf_saf_pos | sort | uniq -d > $intersect

$angsd -bam $bam_list_tremula -minMapQ 30 -minQ 20 -GL 1 -doSaf 1 -out $tremula/tremula_$1 -anc $ref -rf $chr -sites $intersect
$angsd -bam $bam_list_tremuloides -minMapQ 30 -minQ 20 -GL 1 -doSaf 1 -out $tremuloides/tremuloides_$1 -anc $ref -rf $chr -sites $intersect

#$emOptim2 2dsfs $tremula/tremula_$1.saf $tremuloides/tremuloides_$1.saf 48 44 -maxIter 100 -P 4 > $tremula/tremula_tremuloides_$1.2dsfs.sfs

#nsites=$(cat $tremula_fix_pos | wc -l)

#using marginal spectra as priors to calculate Fst between populations, estimated using optimSFS (ANGSD)
#$ngsFst -postfiles $tremula/tremula_$1.rf.fix.saf $tremuloides/tremuloides_$1.rf.fix.saf -priorfiles $tremula/tremula_$1.sfs $tremuloides/tremuloides_$1.sfs -nind 24 22 -outfile $OutDir/tremula_tremuloides.chr$1.fst -nsites $nsites -block_size 20000 -islog 1



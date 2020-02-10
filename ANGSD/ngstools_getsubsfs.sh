#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -n 2
#SBATCH -o ngstools_get_subsfs.out
#SBATCH -e ngstools_get_subsfs.err
#SBATCH -J ngstools_get_subsfs.job
#SBATCH -t 5:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

tremula_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.saf.pos.gz"
tremula_post_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.saf.pos"
tremula_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.pos"

tremula_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.saf"
tremula_out_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremula/tremula_$1/tremula_$1.rf.fix.saf"

tremuloides_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.saf.pos.gz"
tremuloides_post_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.saf.pos"
tremuloides_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.pos"

tremuloides_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.saf"
tremuloides_out_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/tremuloides_$1.rf.fix.saf"

GetSubSfs="/proj/b2011141/tools/ngsTools/ngsUtils/GetSubSfs"


gunzip -c $tremula_pos > $tremula_post_pos 
gunzip -c $tremuloides_pos > $tremuloides_post_pos 

awk 'FNR==NR {x[$1"_"$2]=NR; next} x[$1"_"$2] {print x[$1"_"$2]; print FNR > "/dev/stderr"}' $tremula_post_pos $tremuloides_post_pos >$tremula_fix_pos 2>$tremuloides_fix_pos

tremula_site=$(cat $tremula_post_pos | wc -l)
tremula_len=$(cat $tremula_fix_pos | wc -l )
echo $tremula_site
echo $tremula_len

tremuloides_site=$(cat $tremuloides_post_pos | wc -l)
tremuloides_len=$(cat $tremuloides_fix_pos | wc -l)

$GetSubSfs -infile $tremula_saf -posfile $tremula_fix_pos -nind 24 -nsites $tremula_site -len $tremula_len -outfile $tremula_out_saf 
$GetSubSfs -infile $tremuloides_saf -posfile $tremuloides_fix_pos -nind 22 -nsites $tremuloides_site -len $tremuloides_len -outfile $tremuloides_out_saf 

#rm $tremula_post_pos 
#rm $tremuloides_fix_pos 



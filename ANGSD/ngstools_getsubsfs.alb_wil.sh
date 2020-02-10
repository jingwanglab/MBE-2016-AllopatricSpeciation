#! /bin/bash -l


#set -e
#set -x

#SBATCH -A b2011141
#SBATCH -p core
#SBATCH -o ngstools_get_subsfs.out
#SBATCH -e ngstools_get_subsfs.err
#SBATCH -J ngstools_get_subsfs.job
#SBATCH -t 5:00:00
#SBATCH --mail-user jing.wang@emg.umu.se
#SBATCH --mail-type=ALL

alb_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.saf.pos.gz"
alb_post_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.saf.pos"
alb_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.pos"

alb_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.saf"
alb_out_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/alb/tremuloides_$1.rf.fix.saf"

wil_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil/tremuloides_$1.rf.saf.pos.gz"
wil_post_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil/tremuloides_$1.rf.saf.pos"
wil_fix_pos="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil/tremuloides_$1.rf.pos"

wil_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil/tremuloides_$1.rf.saf"
wil_out_saf="/proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/ANGSD/unfolded_SFS/tremuloides/tremuloides_$1/wil/tremuloides_$1.rf.fix.saf"

GetSubSfs="/proj/b2011141/tools/ngsTools/ngsUtils/GetSubSfs"


gunzip -c $alb_pos > $alb_post_pos 
gunzip -c $wil_pos > $wil_post_pos 

awk 'FNR==NR {x[$1"_"$2]=NR; next} x[$1"_"$2] {print x[$1"_"$2]; print FNR > "/dev/stderr"}' $alb_post_pos $wil_post_pos >$alb_fix_pos 2>$wil_fix_pos

alb_site=$(cat $alb_post_pos | wc -l)
alb_len=$(cat $alb_fix_pos | wc -l )
echo $alb_site
echo $alb_len

wil_site=$(cat $wil_post_pos | wc -l)
wil_len=$(cat $wil_fix_pos | wc -l)

$GetSubSfs -infile $alb_saf -posfile $alb_fix_pos -nind 12 -nsites $alb_site -len $alb_len -outfile $alb_out_saf 
$GetSubSfs -infile $wil_saf -posfile $wil_fix_pos -nind 10 -nsites $wil_site -len $wil_len -outfile $wil_out_saf 

#rm $alb_post_pos 
#rm $wil_fix_pos 



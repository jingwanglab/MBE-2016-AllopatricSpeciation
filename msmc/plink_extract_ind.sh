#! /bin/bash -l

#SBATCH -A b2012210
#SBATCH -p core
#SBATCH -o plink_extract.out
#SBATCH -e plink_extract.err
#SBATCH -J plink_extract.job
#SBATCH -t 1-00:00:00
#SBATCH --mail-user par.ingvarsson@umu.se
#SBATCH --mail-type=ALL

plink="/proj/b2011141/tools/plink_1.9/plink"
ped="/proj/b2011141/nobackup/PaperII-MBE/bwa_mem_alignment/GATK/HC/tremula/total/snp_filter/plink/rm_fixed/Chr$1/SwAsp.trichocarpa.gatk.hap.snp.rm_indel.bed.biallelic.GQ10.rm_miss_1.hwe.plink.ped.ped.$1.ped"

map="/proj/b2011141/nobackup/PaperII-MBE/bwa_mem_alignment/GATK/HC/tremula/total/snp_filter/plink/rm_fixed/Chr$1/SwAsp.trichocarpa.gatk.hap.snp.rm_indel.bed.biallelic.GQ10.rm_miss_1.hwe.plink.ped.ped.$1.map"
ind2="/proj/b2011141/pipeline/msmc/new_trem/ind_tremula_2hap.txt"
ind4="/proj/b2011141/pipeline/msmc/new_trem/ind_tremula_4hap.txt"
ind8="/proj/b2011141/pipeline/msmc/new_trem/ind_tremula_8hap.txt"

OutDir2="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap2/Chr$1"
OutDir4="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap4/Chr$1"
OutDir8="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap8/Chr$1"

## $plink --ped $ped --map $map --keep $ind2 --maf 0.01 --geno 0 --out $OutDir2/SwAsp.hap2.Chr$1 --recode 
## $plink --ped $ped --map $map --keep $ind4 --maf 0.01 --geno 0 --out $OutDir4/SwAsp.hap4.Chr$1 --recode 
$plink --ped $ped --map $map --keep $ind8 --maf 0.01 --geno 0 --out $OutDir8/SwAsp.hap8.Chr$1 --recode 





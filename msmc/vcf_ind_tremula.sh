#! /bin/bash -l

#SBATCH -A b2012141
#SBATCH -p core
#SBATCH -o Vcf_indiv.out
#SBATCH -e Vcf_indiv.err
#SBATCH -J Vcf_indiv.job
#SBATCH -t 6:00:00


module load bioinfo-tools
#module load vcftools

vcftools="/proj/b2011141/tools/vcftools/bin/vcftools"

Inputvcf="/proj/b2011141/nobackup/PaperII-MBE/bwa_mem_alignment/GATK/HC/tremula/total/snp_filter/SwAsp.trichocarpa.gatk.hap.snp.rm_indel.bed.biallelic.GQ10.rm_miss_1.hwe.chr12_uniq.recode.vcf.gz"

VCFDir=`dirname $Inputvcf`
Out=${Inputvcf##*/}
##Chr01-19
chr=$1
###haplotype 2,4,8
hap=$2

OutDir="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap/$chr/vcf"

if [ ! -d "$OutDir" ]; then
mkdir -p $OutDir
fi

Out_ind=${Out%.recode.vcf.gz}.$chr

if [ $hap == 2 ] ; then
$vcftools --gzvcf $Inputvcf --indv "SwAsp001" --chr $chr --maf 0.001 --max-missing-count 1 --recode --recode-INFO-all --out $OutDir/$Out_ind
fi
if [ $hap == 4 ] ; then
$vcftools --gzvcf $Inputvcf --indv "SwAsp001" --indv "SwAsp003" --chr $chr --maf 0.001 --max-missing-count 1 --recode --recode-INFO-all --out $OutDir/$Out_ind
fi
if [ $hap == 8 ] ; then
$vcftools --gzvcf $Inputvcf --indv "SwAsp001" --indv "SwAsp003" --indv "SwAsp005" --indv "SwAsp009" --chr $chr --maf 0.001 --max-missing-count 1 --recode --recode-INFO-all --out $OutDir/$Out_ind
fi




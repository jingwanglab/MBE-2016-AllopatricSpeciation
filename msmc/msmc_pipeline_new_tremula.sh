#! /bin/bash -l

#SBATCH -A b2012141
#SBATCH -p core
#SBATCH -o Vcf_indiv.out
#SBATCH -e Vcf_indiv.err
#SBATCH -J Vcf_indiv.job
#SBATCH -t 6:00:00

module load bioinfo-tools
module load BEDTools/2.16.2

## 1. extract the SNPs for the 2hap(1 ind), 4hap(2ind), 8hap(4ind) fro samples from a single SwAsp population
## to execute: run ./generate_vcf_files.sh

## #2. use BEDTools to extract the bed files which will be used later for producing the input file of msmc
for hap in {2,4,8}
do
    for file in {01..19}
    do
	OutDir="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap/Chr$file"
	bed="/proj/b2011141/nobackup/PaperII-MBE/bwa_mem_alignment/bed/all/Chr/chr/all.filter.Chr$file.bed"
	vcf="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap/Chr$file/vcf/SwAsp.trichocarpa.gatk.hap.snp.rm_indel.bed.biallelic.GQ10.rm_miss_1.hwe.chr12_uniq.Chr$file.recode.vcf"
	bedtools subtract -a $bed -b $vcf > $OutDir/SwAsp.hap$hap.msmc.Chr$file.bed
    done
done

## 3. Extract SNPs by plink with the .ped and .map files
for file in {01..19}
do
    /proj/b2011141/pipeline/msmc/new_trem/plink_extract_ind.sh $file
done

##for chr12 uniq 
for file in {2,4,8}
do
   perl /proj/b2011141/pipeline/perl/map_uniq_chr12.pl /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.map
   sort -k 4,4n /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.uniq.map > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.map
done

## 4. Extract the haplotypes from the hap file
for hap_n in {2,4,8}
do
  for file in {01..19}
  do
      hap="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.fastphase.hap"
      map="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.map"
      perl /proj/b2011141/pipeline/msmc/new_trem/msmc_extrac_ind.SwAsp.$hap_n.pl $hap $map
  done
done

# ###chr12 uniq
for file in {2,4,8}
do
    perl /proj/b2011141/pipeline/perl/hap_uniq_chr12.pl /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.msmc.hap
    mv /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.msmc.uniq.hap /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$file/Chr12/SwAsp.hap$file.Chr12.msmc.hap
done

## 5. Extract information for the third column of the input file, which is the number of called sites (homozygous, except the site itself which can be hom. or het.) since the last segregating site.
for hap_n in {2,4,8}
do
    for file in {01..19}
    do
	bed="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.msmc.Chr$file.bed"
	hap="/proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.hap"
	perl /proj/b2011141/pipeline/msmc/new_trem/bed_called_sites.pl $bed $hap
    done
done

### 6. paste the four columns together
for hap_n in {2,4,8}
do
    for file in {01..19}
    do
	cut -f 1,2 /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.hap > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/pos
	cut -f 3 /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.hap > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/hap
	paste /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/pos /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.msmc.Chr$file.called.sites  /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/hap > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.input
	rm /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/pos /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/hap
    done
done

## 7. modify the output file for small cases

for hap_n in {2,4,8}
do
    for file in {01..19}
    do
	perl /proj/b2011141/pipeline/msmc/new_trem/modify_called_sites.pl /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.input
    done
done

## 8. create the final version of output for msmc
for hap_n in {2,4,8}
do
    for file in {01..19}
    do
	cut -f 1 /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.input > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/chrom
	cut -f 4 /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.input > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/hap
	paste /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/chrom /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.modify.input /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/hap > /proj/b2011141/nobackup/PaperII-MBE/msmc_new_tremula/hap$hap_n/Chr$file/SwAsp.hap$hap_n.Chr$file.msmc.final.input
    done
done


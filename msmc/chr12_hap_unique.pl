#! usr/bin/perl 

use strict;
use File::Basename;

#this script is used to extract the information of angsd_vcf file after annotated by SnpEff, in order to make a Minor allele frequency plot


my $eff_vcf=basename($ARGV[0],"\.hap");
my $dirname=dirname($ARGV[0]);
my $tab=$eff_vcf.".uniq.hap";
my $Output=join "/", ($dirname,$tab);

open HAP, "<", $ARGV[0] or die "cannot open the EFF_VCF file: $!";
open OUT, ">", $Output or die "cannot produce the VENN_PLOT file: $!";

my %hap;

while(<HAP>) {
	chomp;
	my @line = split(/\t/, $_);
	$hap{$line[1]}=$_;	
}

foreach (sort {$a<=>$b} keys %hap){
        print OUT "$hap{$_}\n";
        }


	





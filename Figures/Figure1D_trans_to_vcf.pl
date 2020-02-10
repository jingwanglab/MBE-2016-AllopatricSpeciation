#! usr/bin/perl

use strict;
use File::Basename;


my $derived=basename($ARGV[0],"\.text");
my $dirname=dirname($ARGV[0]);
my $vcf=$derived.".vcf";
my $shared_vcf=$derived.".shared.vcf";
my $tremula_private_vcf=$derived.".tremula.private.vcf";
my $tremuloides_private_vcf=$derived.".tremuloides.private.vcf";
my $tremula_fixed_vcf=$derived.".tremula.fixed.vcf";
my $tremuloides_fixed_vcf=$derived.".tremuloides.fixed.vcf";

my $Output=join "/", ($dirname,$vcf);
my $Output_shared=join "/", ($dirname,$shared_vcf);
my $Output_tremula_private=join "/", ($dirname,$tremula_private_vcf);
my $Output_tremuloides_private=join "/", ($dirname,$tremuloides_private_vcf);
my $Output_tremula_fixed=join "/", ($dirname,$tremula_fixed_vcf);
my $Output_tremuloides_fixed=join "/", ($dirname,$tremuloides_fixed_vcf);

open DERIVED, "<", $ARGV[0] or die "cannot open the derived file: $!";
open VCF, ">", $Output or die "cannot produce the vcf_total file: $!";
open VCF_SHARED, ">", $Output_shared or die "cannot produce the vcf_shared file: $!";
open VCF_TREMULA_PRIVATE, ">", $Output_tremula_private or die "cannot produce the vcf_tremula_private file: $!";
open VCF_TREMULOIDES_PRIVATE, ">", $Output_tremuloides_private or die "cannot produce the vcf_tremuloides_private file: $!";
open VCF_TREMULA_FIXED, ">", $Output_tremula_fixed or die "cannot produce the vcf_tremula_fixed file: $!";
open VCF_TREMULOIDES_FIXED, ">", $Output_tremuloides_fixed or die "cannot produce the vcf_tremuloides_fixed file: $!";


while(<DERIVED>) {
	chomp;
	if ($_=~/^CHROM/) {
		print VCF "##fileformat=VCFv4.1\n";
		print VCF_SHARED "##fileformat=VCFv4.1\n";
		print VCF_TREMULA_PRIVATE "##fileformat=VCFv4.1\n";
		print VCF_TREMULOIDES_PRIVATE "##fileformat=VCFv4.1\n";
		print VCF_TREMULA_FIXED "##fileformat=VCFv4.1\n";
		print VCF_TREMULOIDES_FIXED "##fileformat=VCFv4.1\n";
		print VCF "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		print VCF_SHARED "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		print VCF_TREMULA_PRIVATE "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		print VCF_TREMULOIDES_PRIVATE "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		print VCF_TREMULA_FIXED "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		print VCF_TREMULOIDES_FIXED "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n";
		next; }
	my @line = split(/\t/, $_);
	my $chrom=$line[0]; #scaffold
	my $pos=$line[1]; #position
	my $id='.'; #id
	my $ref=$line[2]; #tremula_derived
	my $alt=$line[3]; #tremuloides_derived
	my $qual='.'; #
	my $filter='.'; #
	my $info='.'; #
	if (($ref==48) && ($alt==44)) {next;}
	elsif (($ref==48) && ($alt==0)) {
	my $format="tremula_fixed";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_TREMULA_FIXED "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	elsif(($ref==48) && ($alt>0)) {
	my $format="shared";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_SHARED "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	elsif(($ref==0) && ($alt==44)) {
	my $format="tremuloides_fixed";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_TREMULOIDES_FIXED "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	elsif(($ref>0) && ($alt==44)) {
	my $format="shared";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_SHARED "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	elsif(($ref>0) && ($alt==0)) {
	my $format="tremula_private";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_TREMULA_PRIVATE "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	elsif(($ref==0) && ($alt>0)) {
	my $format="tremuloides_private";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_TREMULOIDES_PRIVATE "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
	else {
	my $format="shared";
	print VCF "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	print VCF_SHARED "$chrom\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$info\t$format\n";
	}
}
	


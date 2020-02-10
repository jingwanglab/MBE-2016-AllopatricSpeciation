#! usr/bin/perl

use strict;
use File::Basename;


my $summary=basename($ARGV[0],"\.summary");
my $dirname=dirname($ARGV[0]);
my $proportion=$summary.".proportion.summary";
my $Output=join "/", ($dirname,$proportion);

open SUMMARY, "<", $ARGV[0] or die "cannot open the summary file: $!";
open OUTPUT, ">", $Output or die "cannot produce the output file: $!";

while(<SUMMARY>) {
	chomp;
	if ($_=~/^CHROM/) {
		print OUTPUT "CHROM\tPOS\tTotal\tShared_N\ttremula_private_N\ttremuloides_private_N\ttremula_fixed_N\ttremuloides_fixed_N\tShared\ttremula_private\ttremuloides_private\ttremula_fixed\ttremuloides_fixed\n";
		next; }
	my @line = split(/\t/, $_);
	my $chrom=$line[0]; 
	my $pos=$line[1]; 
	my $tremula=$line[2]; 
	my $tremuloides=$line[3];
	my $total=$line[4];
	my $shared=$line[5];
	my $tremula_private=$line[6];
	my $tremuloides_private=$line[7];
	my $tremula_fixed=$line[8];
	my $tremuloides_fixed=$line[9];	
	
	if (($tremula<1000) || ($tremuloides<1000)) {
		print OUTPUT "$chrom\t$pos\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n";
		next;
	 } 
	if ($total<=10) {
		print OUTPUT "$chrom\t$pos\t$total\t$shared\t$tremula_private\t$tremuloides_private\t$tremula_fixed\t$tremuloides_fixed\tNA\tNA\tNA\tNA\tNA\n";
                next;
         }
	else{
	my $shared_pro=sprintf("%.5f",$shared/$total);
	my $tremula_private_pro=sprintf("%.5f",$tremula_private/$total);
	my $tremuloides_private_pro=sprintf("%.5f",$tremuloides_private/$total);
	my $tremula_fixed_pro=sprintf("%.5f",$tremula_fixed/$total);
	my $tremuloides_fixed_pro=sprintf("%.5f",$tremuloides_fixed/$total);
	print OUTPUT "$chrom\t$pos\t$total\t$shared\t$tremula_private\t$tremuloides_private\t$tremula_fixed\t$tremuloides_fixed\t$shared_pro\t$tremula_private_pro\t$tremuloides_private_pro\t$tremula_fixed_pro\t$tremuloides_fixed_pro\n";
	}
}

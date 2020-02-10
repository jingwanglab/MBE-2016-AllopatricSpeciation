#! usr/bin/perl -w

#use strict;
use File::Basename;

#perl gene_enrichment.pl /proj/b2011141/pipeline/R/angsd/fst/significant_loci/fst_df_dxy.99.txt /proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/selection_summary/window_gff/both/trichcoarpa.gene.window


my $genomic=basename($ARGV[0],"\.island");
my $dirname=dirname($ARGV[0]);
my $island_number=$genomic.".island.number";
my $Output=join "/", ($dirname,$island_number);


open ISLAND, "<", $ARGV[0] or die "cannot open the WIN file: $!";
open OUT, ">", $Output or die " cannot produce the WIN_GENE file: $!";

my %island;
$island{1}=0;
my $first_pos="15000";
my $i=1;

while(<ISLAND>) {
        chomp;
	if ($_ =~ /Chr/) {next;}
        my @line=split(/\t/,$_);
        my $pos=$line[1];
	if (($pos-$first_pos)==10000) {
		$island{$i+1}=$island{$i+1}+1;
		$i=$i+1;
	}

	else{
		$i=1;
		$island{$i}=$island{$i}+1;
	}
	$first_pos=$pos
}

foreach (sort {$a<=>$b} keys %island){
        print OUT "$island{$_}\n";
        }



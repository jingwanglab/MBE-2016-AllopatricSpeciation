#! usr/bin/perl -w

use strict;
use File::Basename;

#perl gene_enrichment.pl /proj/b2011141/pipeline/R/angsd/fst/significant_loci/fst_df_dxy.99.txt /proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/selection_summary/window_gff/both/trichcoarpa.gene.window


my $bed=basename($ARGV[0],"\.bed");
my $dirname=dirname($ARGV[0]);
my $bed_gene=$bed.".gene.bed";
my $Output=join "/", ($dirname,$bed_gene);


open WIN, "<", $ARGV[0] or die "cannot open the WIN file: $!";
open GENE, "<", $ARGV[1] or die "cannot open the GENE file: $!";
open WIN_GENE, ">", $Output or die " cannot produce the WIN_GENE file: $!";

my %sig_pos;

while(<WIN>) {
        chomp;
        my @line=split(/\t/,$_);
        my $chrom_win=join"_",($line[0],$line[3]);
                $sig_pos{$chrom_win}=0;
}
close(WIN);

while(<GENE>) {
	chomp;
	my @line=split(/\t/,$_);
	my $chrom_pos=join"_",($line[9],$line[12]);
		$sig_pos{$chrom_pos}=$sig_pos{$chrom_pos}+1;
}		
close(GENE);

open WIN, "<", $ARGV[0] or die "cannot open the WIN file: $!";
while(<WIN>) {
	chomp;
	my @line=split(/\t/,$_);
	my $chrom_win=join"_",($line[0],$line[3]);
	push @line,$sig_pos{$chrom_win};
	print WIN_GENE join("\t",@line[0..$#line]), "\n";
}

	

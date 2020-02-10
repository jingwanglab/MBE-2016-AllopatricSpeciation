#! usr/bin/perl -w

use strict;
use File::Basename;

#perl gene_enrichment.pl /proj/b2011141/pipeline/R/angsd/fst/significant_loci/fst_df_dxy.99.txt /proj/b2011141/nobackup/tremula_vs_tremuloides_paper/bwa_mem_alignment/selection_summary/window_gff/both/trichcoarpa.gene.window


my $sig_win=basename($ARGV[0],"\.txt");
my $dirname=dirname($ARGV[0]);
my $sig_gene=$sig_win.".gene.window";
my $Output=join "/", ($dirname,$sig_gene);


open WIN, "<", $ARGV[0] or die "cannot open the WIN file: $!";
open GENE, "<", $ARGV[1] or die "cannot open the GENE file: $!";
open WIN_GENE, ">", $Output or die " cannot produce the WIN_GENE file: $!";

my %sig_pos;

while(<WIN>) {
        chomp;
        if ($_ =~ /Chr/) {next;}
        my @line=split(/\t/,$_);
        my $chrom_win=join"_",($line[0],$line[1]);
                $sig_pos{$chrom_win}=$_;
}


while(<GENE>) {
	chomp;
	my @line=split(/\t/,$_);
	my $chrom_pos=join"_",($line[0],$line[12]);
	    if (defined $sig_pos{$chrom_pos}) {

		print WIN_GENE join("\t",@line[0..$#line]), "\n";

	#print Region "$line[0]:\n";
}

}
	




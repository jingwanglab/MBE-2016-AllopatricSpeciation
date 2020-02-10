#! usr/bin/perl -w

use strict;
use File::Basename;


my $gene=basename($ARGV[0],"\.tsv");
my $dirname=dirname($ARGV[0]);
my $new=$gene.".one_gene.tsv";
my $Output=join "/", ($dirname,$new);


open GENE, "<", $ARGV[0] or die "cannot open the GENE file: $!";
open OUT, ">", $Output or die " cannot produce the OUT file: $!";

my $old_gene="none";

while(<GENE>) {
        chomp;
        if ($_ =~ /Transcript/) {print OUT "Transcript_Name\tATG_ID\n";next;}
        my @line=split(/\t/,$_);
	my @gene=split(/\./,$line[0]);
	my $gene_name=join(".",($gene[0],$gene[1]));
	my @atg=split(/\./,$line[2]);
	my $atg_name=$atg[0];
	if ($gene_name eq $old_gene) {next;}
	else {
		print OUT "$gene_name\t$atg_name\n";
		$old_gene=$gene_name;
	}
	}



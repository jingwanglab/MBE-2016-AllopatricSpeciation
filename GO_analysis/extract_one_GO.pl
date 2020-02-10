#! usr/bin/perl -w

use strict;
use File::Basename;


my $gene=basename($ARGV[0],"\.tsv");
my $dirname=dirname($ARGV[0]);
my $new=$gene.".go.tsv";
my $Output=join "/", ($dirname,$new);

###perl extract_one_GO.pl both.atg.one_gene.tsv atg.description.go.tsv

open GENE, "<", $ARGV[0] or die "cannot open the GENE file: $!";
open GO, "<", $ARGV[1] or die "cannot open the GO file: $!";
open OUT, ">", $Output or die " cannot produce the OUT file: $!";

my %go;

while(<GO>) {
	chomp;
	if ($_ =~ /Gene/) {next;}
	my @line=split(/\t/,$_);
	$go{$line[0]}=join("\t",($line[1],$line[3]));
}
	
while(<GENE>) {
        chomp;
        if ($_ =~ /Transcript/) {print OUT "Transcript_Name\tATG_ID\tsynonyms\tGO\n";next;}
        my @line=split(/\t/,$_);
	if (defined $go{$line[1]}) {
		print OUT "$line[0]\t$line[1]\t$go{$line[1]}\n";}
	else {
		print OUT "$_\n";
	}
}



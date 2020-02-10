#! usr/bin/perl -w

use strict;
use File::Basename;


my $gene=basename($ARGV[0],"\.tsv");
my $dirname=dirname($ARGV[0]);
my $new=$gene.".description.tsv";
my $Output=join "/", ($dirname,$new);


###perl extract_atg_description.pl both.atg.one_gene.tsv atg.description.go.tsv

open GENE, "<", $ARGV[0] or die "cannot open the GENE file: $!";
open Description, "<", $ARGV[1] or die "cannot open the GO file: $!";
open OUT, ">", $Output or die " cannot produce the OUT file: $!";

my %description;

while(<Description>) {
	chomp;
	if ($_ =~ /Gene/) {next;}
	my @line=split(/\t/,$_);
	$description{$line[0]}=join("\t",($line[1],$line[2]));
}
	
while(<GENE>) {
        chomp;
        if ($_ =~ /Transcript/) {print OUT "Transcript_Name\tATG_ID\tsynonyms\tDescription\n";next;}
        my @line=split(/\t/,$_);
	if (defined $description{$line[1]}) {
		print OUT "$line[0]\t$line[1]\t$description{$line[1]}\n";}
	else {
		print OUT "$_\n";
	}
}



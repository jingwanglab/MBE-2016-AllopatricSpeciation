#! usr/bin/perl -w

use strict;
use File::Basename;

my $hap=basename($ARGV[0],"\.input");
my $dirname=dirname($ARGV[0]);
my $msmc_hap=$hap.".modify.input";
my $Output=join "/", ($dirname,$msmc_hap);

open INPUT, "<", $ARGV[0] or die "cannot open the BED file: $!";
open OUT, ">", $Output or die "cannot produce the OUT file: $!";

my %site;
my $line1=0;

while(<INPUT>) {
	chomp;
        my @line=split(/\t/,$_);
        $site{$line[1]}=$line[2];
}
close(INPUT);
open INPUT, "<", $ARGV[0] or die "cannot open the BED file: $!";

while(<INPUT>){
	chomp;
	my @line=split(/\t/,$_);
	if($line[2]>($line[1]-$line1)){
		$site{$line1}=1;
		$site{$line[1]}=$line[1]-$line1;
	}
	$line1=$line[1];
}


foreach (sort {$a<=>$b} keys %site){
        print OUT "$_\t$site{$_}\n";
        }



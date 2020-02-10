#!/usr/bin/perl -w


use strict;
use File::Basename;

#This script was used to extract the useful information produced by ANGSD Tajima's analysis. The file we used is .thetas.gz.pestPG file


my $final=basename($ARGV[0],"\.final.txt");
my $dirname=dirname($ARGV[0]);
my $plot=$final.".plot.txt";
my $Output=join "/", ($dirname,$plot);

open FINAL, "<", $ARGV[0] or die "cannot open the frq file: $!";
open OUT, ">", $Output or die "cannot produce the maf file: $!";

my $mu=0.0000000375;
my $g=15;


while(<FINAL>) {
	chomp;
	if ($_=~/^time/){print OUT "$_\n";}
	else{
	my @line=split(/\t/, $_);
	my $left_time=sprintf("%.5f",$g*($line[1]/$mu));
	my $right_time=sprintf("%.5f",$g*($line[2]/$mu));
	my $pop_size=sprintf("%.5f",1/($line[3]*2*$mu));
	print OUT "$line[0]\t$left_time\t$right_time\t$pop_size\n";
}
}


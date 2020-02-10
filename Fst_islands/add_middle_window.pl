#! usr/bin/perl -w

use strict;
use File::Basename;

my $bed=basename($ARGV[0],"\.bed");
my $dirname=dirname($ARGV[0]);
my $region=$bed.".middle.bed";
my $Output=join "/", ($dirname,$region);

open BED, "<", $ARGV[0] or die "cannot open the BED file: $!";
open Region, ">", $Output or die " cannot produce the Region file: $!";


while(<BED>) {
	chomp;
	my @line=split(/\t/,$_);
	my $start=$line[1];
	my $middle=$line[1]+5001;

	push @line,$middle;
        print Region join("\t",@line[0..$#line]), "\n";
}


	




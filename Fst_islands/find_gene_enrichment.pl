#! usr/bin/perl -w

use strict;
use File::Basename;

my $bed=basename($ARGV[0],"\.window");
my $dirname=dirname($ARGV[0]);
my $region=$bed.".new.window";
my $Output=join "/", ($dirname,$region);

open BED, "<", $ARGV[0] or die "cannot open the BED file: $!";
open Region, ">", $Output or die " cannot produce the Region file: $!";


while(<BED>) {
	chomp;
	my @line=split(/\t/,$_);
	my $start=$line[10];
	my $middle=$line[10]+5001;

	push @line,$middle;
        print Region join("\t",@line[0..$#line]), "\n";

	#print Region "$line[0]:\n";
}


	




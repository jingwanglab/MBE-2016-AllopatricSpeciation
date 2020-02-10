#! usr/bin/perl -w

use strict;
use File::Basename;

my $hap=basename($ARGV[0],"\.bed");
my $dirname=dirname($ARGV[0]);
my $msmc_hap=$hap.".called.sites";
my $Output=join "/", ($dirname,$msmc_hap);

open BED, "<", $ARGV[0] or die "cannot open the BED file: $!";
open HAP, "<", $ARGV[1] or die "cannot open the HAP file: $!";
open OUT, ">", $Output or die "cannot produce the OUT file: $!";

my %hap;

while(<HAP>) {
	chomp;
        my @map=split(/\t/,$_);
        $hap{$map[1]}=1;
}

my $start=0;
my $end=1;
my $line1=0;
my $line2=10000000000000;

while(<BED>) {
	chomp;
	my @line=split(/\t/,$_);
	
	if (($line[1]>($line2+1)) && (defined $hap{$line[1]})) {
                $hap{$line[1]}=$end-$start;
		$start=0;
		$end=1
        }

	if (defined $hap{($line[2]+1)}) {
                $hap{($line[2]+1)}=($line[2]+$end-$line[1]-$start);
                $start=0;
                $end=1;
        }
	else{
                $start=$start+$line[1];
                $end=$end+$line[2];
        }


	$line1=$line[1];
	$line2=$line[2];	

}

foreach (sort {$a<=>$b} keys %hap){
	print OUT "$hap{$_}\n";
	}


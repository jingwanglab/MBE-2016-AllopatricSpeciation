#! /usr/bin/perl 

use strict;
use File::Basename;

my $map=basename($ARGV[1],"\.map");
my $dirname=dirname($ARGV[1]);
my $msmc_hap=$map.".msmc.hap";
my $Output=join "/", ($dirname,$msmc_hap);


open HAP, "<", $ARGV[0] or die "cannot open the HAP file: $!";
open MAP, "<", $ARGV[1] or die "cannot open the MAP file: $!";
open OUT, ">", $Output or die "cannot produce the OUT file: $!";

my %hap;

while(<MAP>) {
	chomp;
        my @map=split(/\s+/,$_);
        $hap{$map[1]}=join"\t",($map[0],$map[3]);
}


while(<HAP>) {
	chomp;
	my @line=split(/\s+/,$_);
        my $snp=join"\t",($line[0],$line[3]);
        #my $snp_hap=join"",($line[16],$line[17],$line[24],$line[25],$line[30],$line[31],$line[46],$line[47]);
        my $snp_hap=join"",($line[50],$line[51]);
        if (defined $hap{$line[1]}) {
        print OUT "$snp\t$snp_hap\n";
	}
        else{next;}
}



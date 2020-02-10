#! /usr/bin/env perl
use strict;
use warnings;
open(I,"< tremula_tremuloides.all.2dsfs.fs");
my $head=<I>;
chomp $head;
my ($row,$col,$sta)=split(/\s+/,$head);

my $sfs=<I>;
chomp $sfs;
my @sfs=split(/\s+/,$sfs);


print "1 observation\n";
my @up_title=("");
for(my $i=0;$i<$col;$i++){
    push @up_title,"d0_$i";
}
print join "\t",@up_title,"\n";
for(my $i=0;$i<$row;$i++){
    my @line;
    for(my $j=0;$j<$col;$j++){
        my $x=shift @sfs;
        push @line,$x;
    }
    print "d1_$i\t",join "\t",@line,"\n";
}

close I;

#!/usr/local/bin/perl -w
#################################################
#  This script extracts the two letter codes and
#  extended codes from the filenames of old
#  sqltables.
#
#################################################
use strict;
use Data::Dumper;
use DBI;

#  Declare variables
my %var;

my ($short,$short1);
my $name="inp_files.txt";
open(IN, $name)
    or die "Couldn't open file $name: $!";
open (OUT, ">codes.txt");
open (OUT1,">files.txt");
while (<IN>){
chomp($_);
open(FILE, $_)
    or die "Couldn't open file $_: $!";



#store first species
my @temp = split /[-\.]/, $_;
$short=substr $temp[2], 3,2;

if (exists $var{$short}){

}
else {
$var{$short}=$temp[2];
print OUT "$short\t$temp[2]\n";
}


# Store second species
$short1=substr $temp[1], 3,2;

if (exists $var{$short1}){


}
else {

$var{$short1}=$temp[1];
print OUT "$short1\t$temp[1]\n";

}
print OUT1 "$short1-$short\n";


close(FILE);
}
#print "size of hash is".keys (%var)."\n";


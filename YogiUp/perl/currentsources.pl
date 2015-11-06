#!/usr/bin/perl

use strict;
use warnings;
use File::Find;

my $dir='/home/sk11/load2/inptables/inparanoid.sbc.su.se/download/7.0_current/sqltables';

open (IN, "files.txt") or die ("could not open file");
open(NEIGHBORS,">inparanoid_files.txt")  or die ("could not open file");
my @names;
while (<IN>){
  chomp  ($_);
   push ( @names, $_);
 }
File::Find::find(
  sub {

  my $file=$_;

my @temp = split /[-\.]/, $file;

my $part1= substr $temp[2],0,1;
#print "$temp[5]\n";

my $part2= substr $temp[5],0,1;
my $pair1 = $temp[1].uc($part1);
my $pair2= $temp[4].uc($part2);

my $code=$pair1."-".$pair2;
my $code1=$pair2."-".$pair1;
print "$code\n";
if ((grep { $_ eq $code} @names )or (grep { $_ eq $code} @names ))
{
print NEIGHBORS  "$file\n";
}
}, $dir
);

#!/usr/bin/perl

use strict;
use warnings;
use File::Find;
use Cwd;
use File::Find qw(find);
my $mydir="/home/sk11/load2/inptables/inparanoid.sbc.su.se/download/7.0_current/sqltables";
open(OUT, ">out.txt") || die("Could not open file!");


my %codes=( 'Agambiae'=> 'ensAG',
'Hsapiens'=>      'ensHS',
'Amellifera' =>     'ensAM',
'Celegans'   =>   'ensCE',
'Cfamiliaris' =>     'ensCF',
'Dmelanogaster' =>     'ensDM',
'Drerio' =>     'ensDR',
'Frubripes' =>     'ensFR',
'Ggallus' =>     'ensGG',
'Mmusculus' =>     'ensMM',
'Ptroglodytes' =>     'ensPT',
'Rnorvegicus' =>     'ensRN',
'Tnigroviridis' =>     'ensTN',
'Cbriggsae' =>     'modCB',
'Ddiscoideum' =>     'modDD',
'Dpseudoobscura' =>     'modDP',
'Osativa' =>     'modOG',
'Rnorvegicus' =>     'modRR',
'Scerevisiae' =>     'modSC',
'Spombe' =>     'modSP',
'Athaliana' =>     'ncbAT',
'Ecoli' =>     'ncbEC',
'Pfalciparum' =>     'sanPF');

         sub wanted {
  my @temp=split /[-\.]/,$_;
  #my $str1=uc (substr $temp[2],0,1);
  #my $str2=uc (substr $temp[5],0,1);
  my $first_species=$temp[1].$temp[2];
  my  $second_species=$temp[4].$temp[5];
      if (exists $codes{$first_species} && exists $codes{$second_species})
 {

    print OUT "$_\n";
  }
}
find(\&wanted, $mydir);

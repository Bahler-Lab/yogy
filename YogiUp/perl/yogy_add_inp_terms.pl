#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;


my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

open(FILE, $file)
    or die "Couldn't open file $file: $!";

  my %speciescodes=(   'AG'=> 'ensAG',
'HS' =>     'ensHS',
'AM' =>     'ensAM',
'CE' =>     'ensCE',
'CF' =>     'ensCF',
'DM' =>     'ensDM',
'DR' =>     'ensDR',
'FR' =>     'ensFR',
'GG' =>     'ensGG',
'MM' =>     'ensMM',
'PT' =>     'ensPT',
'RN' =>     'ensRN',
'TN' =>     'ensTN',
'CB' =>     'modCB',
'DD' =>     'modDD',
'DP' =>     'modDP',
'OG' =>     'modOG',
'RR' =>     'modRR',
'SC' =>     'modSC',
'SP' =>     'modSP',
'AT' =>     'ncbAT',
'EC' =>     'ncbEC',
'PF' =>     'sanPF');



my $code;
#print "$file\n";
my @temp = split /[-\.]/, $file;
my $part1= substr $temp[2],0,1;
my $part2= substr $temp[5],0,1;
my $pair1 = $temp[1].uc($part1);
my $pair2= $temp[4].uc($part2);
#print "$pair1\t$pair2\n";

 $code=$speciescodes{$pair1}."-".$speciescodes{$pair2};


WHILE:
while (<FILE>) {

    chomp;

    my @tmp = split /\t/;
    my $organsm=(substr $tmp[2],0,1).uc (substr $tmp[2],2,1);

    insert_inparanoid_member_rows($code, $tmp[0], $tmp[1],$speciescodes{$organsm}, $tmp[3], $tmp[4]);
    print ("$code\t$tmp[0]\t$tmp[1]\t$tmp[3]\t$speciescodes{$organsm}\t$tmp[4]\n");


}

close(FILE);

disconnect_from_DB();


sub connect_to_DB {

    my ($driver, $instance, $host, $port, $cnf_file, $user, $password) = @_;

    my $dbh = DBI->connect("DBI:${driver}:database=${instance};host=${host};port=$port;mysql_read_default_file=${cnf_file}",$user,$password)
        or die "ERROR: $DBI::errstr\n";

    if (!defined $dbh) {
        die "Could not connect to database: $!";
    }

    return $dbh;
}


sub disconnect_from_DB {

    $dbh->disconnect()
        or die "Can't disconnect: $DBI::errstr\n";

}


###############################################################################

sub insert_inparanoid_member_rows {

    my $sth_inparanoid = undef;

    my ($pair, $cluster, $score, $organism, $inparalog, $uniprot) = @_;

    unless ($sth_inparanoid) {

        my $string = qq(INSERT INTO inparanoid_member
                        (organism_pair, cluster_nr, main_ortholog_score, organism, inparalog_score, uniprot_id)
                        VALUES (?, ?, ?, ?, ?, ?) );

        $sth_inparanoid = $dbh->prepare($string);

    }

    $sth_inparanoid->execute($pair, $cluster, $score, $organism, $inparalog, $uniprot );

}

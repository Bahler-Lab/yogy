#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);



open(FILE, $file)
    or die "Couldn't open file $file: $!";

my @temp = split /\./, $file;

#print "[@temp]\n";

WHILE:
while (<FILE>) {

    chomp;

    my @tmp = split /\t/;

    insert_inparanoid_member_rows($temp[1], $tmp[0], $tmp[1], $tmp[2], $tmp[3], $tmp[4]);
#           print "$temp[1]\t $tmp[0]\t $tmp[1]\t $tmp[2]\t $tmp[3]\t $tmp[4]\n";
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

        my $string = qq(INSERT IGNORE INTO inparanoid_member
                        (organism_pair, cluster_nr, main_ortholog_score, organism, inparalog_score, uniprot_id)
                        VALUES (?, ?, ?, ?, ?, ?) );

        $sth_inparanoid = $dbh->prepare($string);

    }

    $sth_inparanoid->execute($pair, $cluster, $score, $organism, $inparalog, $uniprot );

}

#!/usr/local/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my $file = shift;

my $dbh = connect_to_DB('mysql','S_pombe_YOGY_2','webdbsrv','3306','','yogyrw','yogyex');


open ORTHOLOGS, $file
    or die "Couldn't open file $file: $!";

while (<ORTHOLOGS>) {

    my @temp = split /\s+/;

    my @tmp = split /\|/, $temp[1];

    my $pombeid = $temp[0];

    foreach (@tmp) {

        insert_val_rows(lc($pombeid),lc($_));

    }

}

close(ORTHOLOGS);

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

sub insert_val_rows {

    my $sth_insert = undef;

    my ($pombe, $yeast) = @_;

    #print "[$pombe] [$yeast]\n";

    unless ($sth_insert) {

        my $string = qq(INSERT INTO vals_orthologs
                        (pombe_id,yeast_id)
                        VALUES (?, ?) );

        $sth_insert = $dbh->prepare($string);

    }

    $sth_insert->execute($pombe, $yeast);

}

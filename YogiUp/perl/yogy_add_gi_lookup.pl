#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);


open(GI, $file)
    or die "Couldn't open file $file: $!";
while (defined (my $line = <GI>) ) {
    chomp $line;
    insert_gi_terms($line);
}
close(GI);
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


sub insert_gi_terms {
    my $line = shift;
    my @array = split /\t/, $line;
    my $insert = qq(INSERT IGNORE INTO gi_lookup (tax_id,
    gene_id,
    prot_acc,
    prot_id)
    VALUES (?, ?, ?, ?)
    );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $array[1] = '-'
    if not $array[1];

    $array[6] = '-'
    if not $array[6];

    $sth->execute($array[0],
        $array[1],
        $array[5],
        $array[6]);
}

#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;
use CGI;

my $file = shift;

my $dbh = connect_to_DB('mysql','S_pombe_YOGY_3','128.40.79.33','3306','','yogyrw','yogyex');


open(GO_TERMS, $file)
    or die "Couldn't open file $file: $!";

WHILE:
while (defined (my $line = <GO_TERMS>) ) {

    next
        if $line =~ /^!/;

    chomp $line;

    #$line =~ s/taxon:(\d+)/$1/;

    #print "[$line]\n";

    my @array = split /\t/, $line;

    $array[12] = substr $array[12], 6;

    next WHILE
        if $array[6] eq 'IEA';

    insert_go_terms(@array);

}

close(GO_TERMS);

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


sub insert_go_terms {

    my @array = @_;

    #my @array = split /\t/, $line;

    #$array[5] = '';

    my $insert = qq(INSERT INTO go_mappings (database_name,
                                             database_id,
                                             database_symbol,
                                             qualifier,
                                             go_id,
                                             db_reference,
                                             evidence,
                                             with_from,
                                             aspect,
                                             db_name,
                                             db_synonym,
                                             db_type,
                                             taxon,
                                             date,
                                             assigned_by)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                   );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $sth->execute($array[0],
                  $array[1],
                  $array[2],
                  $array[3],
                  $array[4],
                  $array[5],
                  $array[6],
                  $array[7],
                  $array[8],
                  $array[9],
                  $array[10],
                  $array[11],
                  $array[12],
                  $array[13],
                  $array[14])
        or warn "Can't execute: $DBI::errstr\n";

}

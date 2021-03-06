#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;
use CGI;

my @species_taxids = qw(3702 6239 7227 9606 4932 4896 6035 7165
                        6238 7955 31033 9031 10090 9598 10116
                        4530 5833 562 148305 5141 33169 7460
                        9615 99883 44689 7237 28985
                        284812 284813 180454 208526 39947 36329 242507);

#@species_taxids2 = qw(3702 6239 7227 9606 4932 284812 284813 180454
#                      6238 7955 31033 208526 10090 9598 10116
#                      39947 36329 562 242507 5141 33169 7460
#                      9615 99883 44689 7237 284590);


my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

open(GO_TERMS, $file)
    or die "Couldn't open file $file: $!";

WHILE:
while (defined (my $line = <GO_TERMS>) ) {

    next
        if $line =~ /^!/;

    chomp $line;

#    $line =~ s/taxon:(\d+)/$1/;

    my @array = split /\t/, $line;

    $array[12] = substr $array[12], 6;

    next WHILE
        if $array[6] eq 'IEA';

    foreach my $tax (@species_taxids) {

        if ($array[12] eq $tax) {

            insert_go_terms(@array);

            #print "[$array[12]]\n";

            next WHILE;

        }

    }

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

    my $insert = qq(INSERT IGNORE INTO go_mappings (database_name,
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

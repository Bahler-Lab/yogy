#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

open(UNI, $file)
    or die "Couldn't open file $file: $!";
while (defined (my $line = <UNI>) ) {
    chomp $line;
    insert_uni_terms($line);
}
close(UNI);
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


sub insert_uni_terms {
    my $line = shift;
    my @array = split /\t/, $line;
    my @accs = split /;/, $array[1];
    foreach my $acc (@accs) {
        my $insert = qq(INSERT IGNORE INTO uniprot_lookup (uni_name,
                                                    pri_uni_acc,
                                                    uni_acc,
                                                    gb_dna_acc,
                                                    gb_prot_acc)
                        VALUES (?, ?, ?, ?, ?)
                       );

        my $sth = $dbh->prepare($insert)
            or die "Can't prepare: $DBI::errstr\n";

        $sth->execute($array[0],
                      $accs[0],
                      $acc,
                      $array[2],
                      $array[3])
            or warn "Can't execute: $DBI::errstr\n";
    }
}

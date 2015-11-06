#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

#my $file = shift;
my $file = "gene2accession";
my $dbh = connect_to_DB('mysql','S_pombe_YOGY_3','128.40.79.33','3306','','yogyrw','yogyex');


open(GI, $file)
    or die "Couldn't open file $file: $!";

while (defined (my $line = <GI>) ) {

    chomp $line;

    #print "[$line]\n";

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

   #print "$array[0] \t$array[1] \t$array[5]\t $array[6]\n";

    my $insert = qq(INSERT INTO gi_lookup (tax_id,
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
        #or warn "Can't execute: $DBI::errstr\n";

}

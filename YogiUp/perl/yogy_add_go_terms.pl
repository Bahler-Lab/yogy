#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;
use CGI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);


# http://www.geneontology.org/doc/GO.terms_ids_obs

open(INPUT, "< $file")
    or die "couldn't open file $file\n";

while (<INPUT>) {

    next
        if /^\!/;

    my @temp = split/\t/;

    my @insert = insert_go_term_rows($temp[0], $temp[1], $temp[2], $temp[3])
        if !m/^>>/;

}

close(INPUT);

disconnect_from_DB();


sub connect_to_DB {

    my ($driver, $instance, $host, $port, $cnf_file, $user, $password) = @_;

    my $dbh = DBI->connect("DBI:${driver}:database=${instance};host=${host};port=$port;mysql_read_default_file=${cnf_file}",$user,$password)
        or die "ERROR:$DBI::errstr\n";

    if (!defined $dbh) {
        die "Could not connect to database";
    }

    return $dbh;
}


sub disconnect_from_DB {

    $dbh->disconnect()
        or die "Can't disconnect: $DBI::errstr\n";

}


###############################################################################

sub insert_go_term_rows {

    my $sth_insert_gi = undef;

    my ($go_id, $go_desc, $asp, $obs) = @_;

    unless ($sth_insert_gi) {

        my $string = qq(INSERT INTO go_terms
                        (go_id, go_desc, aspect, obsolete)
                        VALUES (?, ?, ?, ?) );

        $sth_insert_gi = $dbh->prepare($string);

    }

    $sth_insert_gi->execute($go_id, $go_desc, $asp, $obs);

}

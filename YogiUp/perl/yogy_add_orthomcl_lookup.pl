#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

open(ORTHO, $file)
    or die "Couldn't open file $file: $!";

<ORTHO>;

while (defined (my $line = <ORTHO>) ) {

    chomp $line;

    my @array = split ' ', $line;

    my $org = substr $array[0], 0, 3;

    my $id1 = '';
#    my $id2 = '';

#    if ($org eq 'pfa' or
#        $org eq 'pyo' or
#        $org eq 'ath') {

#        $id1 = $array[1];
#        $id2 = $array[2];

#    } elsif ($org eq 'pvi') {

#        $id1 = $array[2];
#        $id2 = $array[1];

#    } elsif ($org eq 'sce') {

#        $id1 = $array[1];
#        $id2 = $array[2];

#        $id2 =~ s/^SGDID://;
#        $id2 =~ s/,$//;

#    } elsif ($org eq 'cel') {

#        $id1 = $array[2];
#        $id2 = $array[3];

#    } elsif ($org eq 'cne') {

#        $id1 = (split /\|/, $array[2])[1];
#        $id2 = $array[1];

#    } elsif ($org eq 'ago') {

#        $id1 = (split /\|/, $array[1])[1];

#    } elsif ($org eq 'cme') {

#        $id1 = (split /\|/, $array[1])[2];

#    } elsif ($org eq 'ncr') {

#        $id1 = $array[1];

#        $id1 =~ s/^\(//;
#        $id1 =~ s/\)$//;

#    } elsif ($org eq 'osa') {

#        $id1 = $array[1];
#        $id2 = (split /\|/, $array[2])[2];

#    } else {

    my $tmp = $array[1];

    if (substr($tmp, 0, 3) eq 'gi|') {

        #$id2 = (split /\|/, $array[1])[1];
        #$id1 = (split /\|/, $array[1])[3];

        $id1 = (split /\|/, $array[1])[1];

    } elsif (substr($tmp, 0, 4) eq 'gnl|') {

        $id1 = (split /\|/, $array[1])[2];

    } else {

        $id1 = $tmp;

    }

#    }

    #print "[$array[0]] [$id1] [$id2]\n";

    insert_orthomcl_lookup_lines($array[0], $id1);

}

close(ORTHO);

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


sub insert_orthomcl_lookup_lines {

    my $ortho_id = shift;
    my $db_id1   = shift;

    my $insert = qq(INSERT INTO orthomcl_lookup (ortho_id,
                                                 db_id1)
                    VALUES (?, ?)
                   );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $sth->execute($ortho_id, $db_id1)
        or warn "Can't execute: $DBI::errstr\n";

}

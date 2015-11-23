#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;


my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

open(ORTHO, $file)
    or die "Couldn't open file $file: $!";

while (defined (my $line = <ORTHO>) ) {

    undef my $gene;

    chomp $line;

    #$line =~ s/^ORTHOMCL(\d+)\((\d+) genes,(\d+) taxa\): //;
    $line =~ s/^OG1_(\d+)\((\d+) genes,(\d+) taxa\): //;

    my @array = split ' ', $line;

    #print "[OG1_$1] [$2] [$3]\n";

    insert_orthomcl_cluster_lines($1, $2, $3);

    my $cluster_id = $1;

    foreach my $entry (@array) {

        $entry =~ /^([a-z]{3}\d+)\(([a-z]{3})\)/;

        $gene->{$1} = $2;

    }

    #print Dumper $gene;

    foreach my $key (sort keys %{$gene}) {

        #print "[$key] [$gene->{$key}]\n";

        insert_orthomcl_member_lines($cluster_id, $key, $gene->{$key});

    }

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


sub insert_orthomcl_cluster_lines {

    my $cluster_id = shift;
    my $no_genes   = shift;
    my $no_taxa    = shift;

    my $insert = qq(INSERT INTO orthomcl_cluster (cluster_id,
                                                  no_genes,
                                                  no_taxa)
                    VALUES (?, ?, ?)
                   );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $sth->execute($cluster_id, $no_genes, $no_taxa)
        or warn "Can't execute: $DBI::errstr\n";

}

sub insert_orthomcl_member_lines {

    my $cluster_id = shift;
    my $ortho_id   = shift;
    my $org_tlc    = shift;

    my $insert = qq(INSERT INTO orthomcl_member (cluster_id,
                                                 ortho_id,
                                                 org_tlc)
                    VALUES (?, ?, ?)
                   );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $sth->execute($cluster_id, $ortho_id, $org_tlc)
        or warn "Can't execute: $DBI::errstr\n";

}

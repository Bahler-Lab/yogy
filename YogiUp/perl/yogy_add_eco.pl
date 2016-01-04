#!/usr/bin/perl -w

use strict;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);


# Go to http://ecogene.org/DatabaseTable.php

# Deselect 'exclude pseudogenes'
# Select the following fields:
#   EcoGene ID (EG)
#   Gene Name (GN)
#   SwissProt ID (SP)
#   GenBank GI ID (GI)
#   Description (Description)

# Download the file and rename it 'EcoData.txt'


open(FILE, $file)
    or die "couldn't open file $file: $!";

<FILE>;

while (<FILE>) {

    chomp;

    my @array = split /\t/;

    my $eco_id = $array[0];
    my $eco_name = $array[1];
    my $uni_id = $array[2];
    my $prot_gi = $array[3];
    my $eco_desc = $array[4];

    my $gene_id = '';
    my $prot_acc = '';
    my $prot_id = '';
    my $prot_acc_ref = '';
    my $prot_id_ref = '';

    if ($prot_gi =~ /^g/ or $prot_gi =~ /^\d+$/) {

        $prot_gi =~ s/^g(\d+)$/$1/;

        $gene_id = get_eco_gene_id($prot_gi);

        if ($gene_id) {

            ($prot_acc, $prot_id) = get_eco_accs($gene_id);

            $prot_acc = '' if not $prot_acc;
            $prot_id = '' if not $prot_id;

            ($prot_acc_ref, $prot_id_ref) = get_eco_accs_ref($gene_id);

            $prot_acc_ref = '' if not $prot_acc_ref;
            $prot_id_ref = '' if not $prot_id_ref;

        } else {

            $gene_id = '';

        }

    } elsif ($prot_gi eq 'Null') {

        # Do nothing

    } else {

        print "[$eco_id] does not have a normal GI.\n";

    }

    insert_eco_rows($eco_id,
                    $eco_name,
                    $uni_id,
                    $gene_id,
                    $prot_id,
                    $prot_acc,
                    $prot_id_ref,
                    $prot_acc_ref,
                    $eco_desc);

}

close FILE;


disconnect_from_DB();


# Subroutines #################################################################

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


sub insert_eco_rows {

    my (@array) = @_;

    my $string = qq(INSERT INTO eco_gene
                    (eco_id, eco_name, uni_id, gene_id, prot_gi, prot_acc, ref_gi, ref_acc, eco_descrip)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array);

}


sub get_eco_gene_id {

    my $prot_gi = shift;
    my $eco_taxid = '83333';

    my $query = qq(SELECT gene_id
                   FROM   gi_lookup
                   WHERE  prot_id = ?
                   AND    tax_id = $eco_taxid);

    my $sth_query = $dbh->prepare($query);

    $sth_query->execute($prot_gi);

    my @row = $sth_query->fetchrow_array();

#    print "[@row]\n";

    return $row[0];

}


sub get_eco_accs {

    my $gene_id = shift;
    my $eco_taxid = '83333';

    my $query = qq(SELECT prot_acc, prot_id
                   FROM   gi_lookup
                   WHERE  gene_id = ?
                   AND    tax_id = $eco_taxid
                   AND    prot_acc NOT LIKE 'NP_%');

    my $sth_query = $dbh->prepare($query);

    $sth_query->execute($gene_id);

    my @row = $sth_query->fetchrow_array();

#    print "[@row]\n";

    return ($row[0], $row[1]);

}


sub get_eco_accs_ref {

    my $gene_id = shift;
    my $eco_taxid = '83333';

    my $query = qq(SELECT prot_acc, prot_id
                   FROM   gi_lookup
                   WHERE  gene_id = ?
                   AND    tax_id = $eco_taxid
                   AND    prot_acc LIKE 'NP_%');

    my $sth_query = $dbh->prepare($query);

    $sth_query->execute($gene_id);

    my @row = $sth_query->fetchrow_array();

#    print "[@row]\n";

    return ($row[0], $row[1]);

}

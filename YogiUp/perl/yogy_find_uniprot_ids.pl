#!/usr/bin/perl -w

use strict;

use DBI;

use Data::Dumper;

use vars qw(%species_tax_hash %species_tax_hash_rev2);
#open (OUT,">trial.txt");

%species_tax_hash = (3702   => '10',
                     6239   => '20',
                     7227   => '30',
                     9606   => '40',
                     4932   => '50',
                     4896   => '60',
                     6035   => '70',
                     7165   => '80',
                     6238   => '90',
                     7955   => '100',
                     31033  => '110',
                     9031   => '120',
                     10090  => '130',
                     9598   => '140',
                     10116  => '150',
                     4530   => '160',
                     5833   => '170',
                     562    => '180',
                     148305 => '190',
                     5141   => '200',
                     33169  => '210',
                     7460   => '220',
                     9615   => '230',
                     99883  => '240',
                     44689  => '250',
                     7237   => '260',
                     28985  => '270');

%species_tax_hash_rev2 = (10  => '3702',
                          20  => '6239',
                          30  => '7227',
                          40  => '9606',
                          50  => '4932',
                          60  => '284812',
                          70  => '284813',
                          80  => '180454',
                          90  => '6238',
                          100 => '7955',
                          110 => '31033',
                          120 => '208526',
                          130 => '10090',
                          140 => '9598',
                          150 => '10116',
                          160 => '39947',
                          170 => '36329',
                          180 => '562',
                          190 => '242507',
                          200 => '5141',
                          210 => '33169',
                          220 => '7460',
                          230 => '9615',
                          240 => '99883',
                          250 => '44689',
                          260 => '7237',
                          270 => '284590');


my $dbh = connect_to_DB('mysql','S_pombe_YOGY_3','128.40.79.33','3306','','yogyrw','yogyex');


#test_query($dbh);


my $results = undef;

$results = get_all_kogs_ids($dbh);

#print Dumper $results;

print "KOGs GI nos: ", scalar @{$results}, "\n";

my $count = 0;

foreach my $data (@$results) {

    my $uni_id = get_uniprot_id($dbh, $data->[1], $species_tax_hash_rev2{$data->[0]});

    #print "R1: [$data->[1]] [$uni_id]\n\n";

    $count++;

    print "$count\r";

    my $check = check_yogy_uniprot_id($dbh, $data->[1], $uni_id);

    insert_yogy_uniprot_id($dbh, $data->[1], $uni_id)
        if not $check;

}


$results = get_all_homologene_ids($dbh);

#print Dumper $results;

print "Homologene GI nos: ", scalar @{$results}, "\n";

$count = 0;

foreach my $data (@$results) {

   # my $species = $species_tax_hash{$data->[0]};
   # print OUT "$species\n";
    my $uni_id = get_uniprot_id($dbh, $data->[1], $species_tax_hash_rev2{$data->[0]});

    #print "R2: [$data->[1]] [$uni_id]\n\n";

    $count++;

    print "$count\r";

    my $check = check_yogy_uniprot_id($dbh, $data->[1], $uni_id);

    insert_yogy_uniprot_id($dbh, $data->[1], $uni_id)
        if not $check;

}

disconnect_from_DB();



###############################################################################

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

sub test_query {

    my ($dbh) = @_;

    undef my @query;

    my $string = qq(SELECT *
                    FROM   gene
                    WHERE  GeneDB_primary = 'tea1');

    my $sth_querya = $dbh->prepare($string);

    $sth_querya->execute();

    @query = $sth_querya->fetchrow_array();

    print "[@query]\n";

    return;

}


###############################################################################

sub get_all_kogs_ids {

    my $dbh = shift;

    undef my $results;

    my $string = qq(SELECT species_id,
                           gi_number
                    FROM   kog_member);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute();

    while (my @query = $sth_query->fetchrow_array() ) {

        #print "[@query]\n";

        push @{$results}, [@query];

    }

    return $results;

}


###############################################################################

sub get_all_homologene_ids {

    my $dbh = shift;

    undef my $results;

    my $string = qq(SELECT tax_id,
                           gi_number
                    FROM   homologene);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute();

    while (my @query = $sth_query->fetchrow_array() ) {

        #print "[@query]\n";

        push @{$results}, [@query];

    }

    return $results;

}


###############################################################################

sub get_uniprot_id {

    my ($dbh, $gi, $tax_id) = @_;

    undef my @query;
    undef my @query3;

    my $string = qq(SELECT gene_id
                    FROM   gi_lookup
                    WHERE  prot_id = ?
                    AND    tax_id  = ?);

    my $sth_querya = $dbh->prepare($string);

    $sth_querya->execute($gi, $tax_id);

    @query = $sth_querya->fetchrow_array();

    #print "A: [$gi] [@query]\n";

    my $string2 = qq(SELECT prot_acc
                     FROM   gi_lookup
                     WHERE  gene_id = ?
                     AND    tax_id  = ?
                     AND    prot_acc NOT LIKE 'NP_%'
                     AND    prot_acc NOT LIKE 'YP_%'
                     AND    prot_acc NOT LIKE 'XP_%');

    my $sth_queryb = $dbh->prepare($string2);

    $sth_queryb->execute($query[0], $tax_id);

    while (my @query2 = $sth_queryb->fetchrow_array() ) {

        next
            if $query2[0] eq '-';

        #print "B: [$query[0]] [@query2]\n";

        last
            unless defined $query2[0] or $query2[0];

        if ($query2[0] =~ /^([OPQ][\d][A-Z\d]{3}\d)/) {

            return $1;

        }

        my $string3 = qq(SELECT pri_uni_acc
                         FROM   uniprot_lookup
                         WHERE  gb_prot_acc = ?);

        my $sth_queryc = $dbh->prepare($string3);

        $sth_queryc->execute($query2[0]);

        @query3 = $sth_queryc->fetchrow_array();

        next
            if defined $query3[0] and $query3[0] eq '-';

        #print "C: [$query2[0]] [@query3]\n";

        last
            if defined $query3[0] and $query3[0];

    }

    $query3[0] = ''
        unless defined $query3[0] or $query3[0];

    return $query3[0];

}


###############################################################################

sub check_yogy_uniprot_id {

    my ($dbh, $yogy, $uni) = @_;

    my $string = qq(SELECT yogy_id,
                           uni_id
                    FROM   yogy_uniprot_lookup
                    WHERE  yogy_id = ?
                    AND    uni_id  = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($yogy, $uni);

    my @query = $sth_query->fetchrow_array();

    return 1
        if defined $query[0] or $query[0];

    return 0;

}


###############################################################################

sub insert_yogy_uniprot_id {

    my ($dbh, $yogy, $uni) = @_;

    my $insert = qq(INSERT INTO yogy_uniprot_lookup (yogy_id,
                                                     uni_id)
                    VALUES (?, ?)
                   );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $yogy = '-'
        if not $yogy;

    $sth->execute($yogy, $uni)
        or warn "Can't execute: $DBI::errstr\n";

}

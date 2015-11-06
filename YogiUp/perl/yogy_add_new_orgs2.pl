#!/usr/local/bin/perl -w

use strict;
use DBI;

my $dbh = connect_to_DB('mysql','S_pombe_YOGY_2','webdbsrv','3306','','yogyrw','yogyex');


my $file = '';

my $query     = '';
my $sth_query = undef;

my $tmp = '';

my $tax_id = 0;
my $org = '';
my $species_id = 0;
my $species_tlc = '';


# MOUSE.

# ftp://ftp.informatics.jax.org/pub/reports/MRK_SwissProt_TrEMBL.rpt

$file = 'MRK_SwissProt_TrEMBL.rpt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    insert_mouse_rows($_);

}

close FILE;


$org = 'ensMM';

$query = qq(SELECT uniprot_id
            FROM   inparanoid_member
            WHERE  organism = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($org);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_mouse_id($row[0]);

    next
        if $id;

    insert_mouse_rows2($row[0]);

}


$species_tlc = 'mmu';

$query = qq(SELECT db_id1
            FROM   orthomcl_lookup
            WHERE  ortho_id LIKE ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_tlc . '%');

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_mouse_id($row[0]);

    next
        if $id;

    insert_mouse_rows2($row[0]);

}


# RAT.

# ftp://rgd.mcw.edu/pub/data_release/GENES

$file = 'GENES';

open(FILE, $file)
    or die "couldn't open file $file: $!";

$tmp = <FILE>;

while (<FILE>) {

    chomp;

    insert_rat_rows($_);

}

close FILE;


$org = 'ensRN';

$query = qq(SELECT uniprot_id
            FROM   inparanoid_member
            WHERE  organism = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($org);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_rat_id($row[0]);

    next
        if $id;

    insert_rat_rows2($row[0]);

}


$species_tlc = 'rno';

$query = qq(SELECT db_id1
            FROM   orthomcl_lookup
            WHERE  ortho_id LIKE ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_tlc . '%');

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_rat_id($row[0]);

    next
        if $id;

    insert_rat_rows2($row[0]);

}


# WORM.

# ftp://ftp.wormbase.org/pub/wormbase/genomes/elegans/annotations/functional_descriptions/current.txt.gz

$file = 'functional_descriptions.WS152.txt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    insert_worm_gene_rows($_);

}

close FILE;


# ftp://ftp.wormbase.org/pub/wormbase/genomes/elegans/annotations/SwissProt/current.txt.gz

$file = 'SwissProt_mappings.WS152.txt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

$tmp = <FILE>;

while (<FILE>) {

    chomp;

    insert_worm_pep_rows($_);

}

close FILE;


# FLY.

# http://flybase.bio.indiana.edu/genes/lk/cg_fbgn.txt

$file = 'cg_fbgn.txt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

$tmp = <FILE>;

while (<FILE>) {

    chomp;

    insert_fly_rows($_);

}

close FILE;


$species_id = '30';

$query = qq(SELECT DISTINCT(protein_id)
            FROM   kog_member
            WHERE  species_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_fly_id($row[0]);

    next
        if $id;

    insert_fly_rows2($row[0]);

}


$query = qq(SELECT DISTINCT(gi_number)
            FROM   kog_member
            WHERE  species_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_fly_id($row[0]);

    next
        if $id;

    insert_fly_rows2($row[0]);

}


# ARABIDOPSIS.

# ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR6_genome_release/TAIR6_NCBI_mapping_prot

$file = 'TAIR6_NCBI_mapping_prot';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    insert_arab_rows($_);

}

close FILE;


# PLASMODIUM.

$org = 'sanPF';

$query = qq(SELECT uniprot_id
            FROM   inparanoid_member
            WHERE  organism = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($org);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_plasmo_id($row[0]);

    next
        if $id;

    insert_plasmo_rows($row[0]);

}


$tax_id = '5833';

$query = qq(SELECT gene_symbol
            FROM   homologene
            WHERE  tax_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($tax_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_plasmo_id($row[0]);

    next
        if $id;

    insert_plasmo_rows($row[0]);

}


$tax_id = '5833';

$query = qq(SELECT gene_symbol
            FROM   homologene
            WHERE  tax_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($tax_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_plasmo_id($row[0]);

    next
        if $id;

    insert_plasmo_rows($row[0]);

}


# HUMAN.

$org = 'ensHS';

$query = qq(SELECT uniprot_id
            FROM   inparanoid_member
            WHERE  organism = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($org);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_human_id($row[0]);

    next
        if $id;

    insert_human_rows($row[0]);

}


$tax_id = '9606';

$query = qq(SELECT gene_symbol
            FROM   homologene
            WHERE  tax_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($tax_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_human_id($row[0]);

    next
        if $id;

    insert_human_rows($row[0]);

}


$species_id = '40';

$query = qq(SELECT DISTINCT(protein_id)
            FROM   kog_member
            WHERE  species_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_human_id($row[0]);

    next
        if $id;

    insert_human_rows($row[0]);

}


$query = qq(SELECT DISTINCT(gi_number)
            FROM   kog_member
            WHERE  species_id = ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_id);

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_human_id($row[0]);

    next
        if $id;

    insert_human_rows($row[0]);

}


$species_tlc = 'hsa';

$query = qq(SELECT db_id1
            FROM   orthomcl_lookup
            WHERE  ortho_id LIKE ?);

$sth_query = $dbh->prepare($query);

$sth_query->execute($species_tlc . '%');

while (my @row = $sth_query->fetchrow_array() ) {

    my $id = get_human_id($row[0]);

    next
        if $id;

    insert_human_rows($row[0]);

}


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


sub get_mouse_id {

    my ($id) = @_;

    my $string = qq(SELECT MGI_id
                    FROM   mouse_gene
                    WHERE  MGI_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}

sub insert_mouse_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO mouse_gene
                    (MGI_id, MGI_name, MGI_num, MGI_descrip, MGI_type, MGI_chr, uni_id)
                    VALUES (?, ?, ?, ?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array);

}

sub insert_mouse_rows2 {

    my ($id) = @_;

    my $string = qq(INSERT INTO mouse_gene
                    (MGI_id, MGI_name, MGI_num, MGI_descrip, MGI_type, MGI_chr, uni_id)
                    VALUES (?, ?, ?, ?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, '', '', '', '', '', '');

}

sub get_rat_id {

    my ($id) = @_;

    my $string = qq(SELECT RGD_id
                    FROM   rat_gene
                    WHERE  RGD_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}

sub insert_rat_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO rat_gene
                    (RGD_id, RGD_name, RGD_descrip, RGD_chr, uni_id)
                    VALUES (?, ?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array[0,1,2,4,11]);

}

sub insert_rat_rows2 {

    my ($id) = @_;

    my $string = qq(INSERT INTO rat_gene
                    (RGD_id, RGD_name, RGD_descrip, RGD_chr, uni_id)
                    VALUES (?, ?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, '', '', '', '');

}

sub insert_worm_gene_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO worm_gene
                    (WB_id, WB_name, CE_id, WB_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array[0..3]);

}

sub insert_worm_pep_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO worm_pep
                    (WP_id, CE_id, uni_id, CE_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array[0,1,3,4]);

}

sub insert_fly_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO fly_gene
                    (DM_id, FB_id, FB_name, FB_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array[0,2,3,4]);

}

sub get_fly_id {

    my ($id) = @_;

    my $string = qq(SELECT DM_id
                    FROM   fly_gene
                    WHERE  DM_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}

sub insert_fly_rows2 {

    my ($id) = @_;

    my $string = qq(INSERT INTO fly_gene
                    (DM_id, FB_id, FB_name, FB_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, '', '', '');

}

sub insert_arab_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO arab_gene
                    (TAIR_id, prot_acc, prot_gi)
                    VALUES (?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array);

}

sub get_plasmo_id {

    my ($id) = @_;

    my $string = qq(SELECT plasmo_id
                    FROM   plasmo_gene
                    WHERE  plasmo_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}

sub insert_plasmo_rows {

    my ($id) = @_;

    my $string = qq(INSERT INTO plasmo_gene
                    (plasmo_id)
                    VALUES (?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id);

}

sub get_human_id {

    my ($id) = @_;

    my $string = qq(SELECT human_id
                    FROM   human_gene
                    WHERE  human_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}

sub insert_human_rows {

    my ($id) = @_;

    my $string = qq(INSERT INTO human_gene
                    (human_id)
                    VALUES (?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id);

}

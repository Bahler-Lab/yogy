#!/usr/bin/perl -w

use strict;
use DBI;

my $dbh = connect_to_DB('mysql','S_pombe_YOGY_3','128.40.79.33','3306','','yogyrw','yogyex');


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

# Download the latest and change the name.

$file = 'functional_descriptions.WS190.txt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    insert_worm_gene_rows($_);

}

close FILE;


# ftp://ftp.wormbase.org/pub/wormbase/genomes/elegans/annotations/SwissProt/current.txt.gz

# Download the latest and change the name.

$file = 'SwissProt_mappings.WS190.txt';

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

#$file = 'cg_fbgn.txt';
$file = 'gene_orthologs_fb_2010_06.tsv';

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

$file = 'TAIR9_NCBI_REFSEQ_mapping_PROT';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    insert_arab_rows($_);

}

close FILE;


# PLASMODIUM.

# http://www.plasmodb.org/download/release-5.0/Pfalciparum/PfalciparumAnnotatedProteins_plasmoDB-5.0.fasta
$file= 'PfalciparumAnnotatedProteins_PlasmoDB-6.3.fasta';
#$file = 'PfalciparumAnnotatedProteins_plasmoDB-5.0.fasta';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    next
        unless /^>/;

    chomp;

    my @array = split /[\=\|]/;
    #my @array2= split (/\-/,$array[1]);
   # $array[1]= substr $array[1],0,5;
    #$array[1] =~ s/^MAL//;
    
    #$array[3] =~ s/\(protein coding\) //;

    insert_plasmo_rows(@array[1,7,5]);

}

close FILE;


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


# DICTY.

# http://dictybase.org/db/cgi-bin/dictyBase/download/download.pl?area=general&ID=gene_information.txt

$file = 'gene_information.txt';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    my @array = split /\t/;

    #print "[@array]\n";

    insert_dicty_rows(@array);

}

close FILE;

# file from Pascale Gaudet at dicty-base as some ID's are different in inparanoid:
#   inparanoid_submission_01172005.ddb

$file = 'inparanoid_submission_01172005.ddb';

open(FILE, $file)
    or die "couldn't open file $file: $!";

while (<FILE>) {

    chomp;

    my $id = get_dicty_id($_);

    next
        if $id;

    insert_dicty_rows2($_);

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

    $sth_insert->execute(@array[0,1,2,3]);

}

sub insert_fly_rows {

    my ($line) = @_;

    my @array = split /\t/, $line;

    my $string = qq(INSERT INTO fly_gene
                    (DM_id, FB_id, FB_name, FB_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array[1,0,3,3]);

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
                    (prot_gi,prot_acc,TAIR_id)
                    VALUES (?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute(@array);

}

sub insert_plasmo_rows {

    my ($id, $chr, $desc) = @_;

    my $string = qq(INSERT INTO plasmo_gene
                    (plasmo_id, plasmo_chr, plasmo_descrip)
                    VALUES (?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, $chr, $desc);

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

sub get_dicty_id {

    my ($id) = @_;

    my $string = qq(SELECT dicty_id
                    FROM   dicty_gene
                    WHERE  dicty_id = ?);

    my $sth_query = $dbh->prepare($string);

    $sth_query->execute($id);

    my @row = $sth_query->fetchrow_array();

    return $row[0];

}


sub insert_dicty_rows {

    my ($id, $name, $syn, $desc) = @_;

    my $string = qq(INSERT INTO dicty_gene
                    (dicty_id, dicty_name, dicty_syn, dicty_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, $name, $syn, $desc);

}


sub insert_dicty_rows2 {

    my ($id) = @_;

    my $string = qq(INSERT INTO dicty_gene
                    (dicty_id, dicty_name, dicty_syn, dicty_descrip)
                    VALUES (?, ?, ?, ?) );

    my $sth_insert = $dbh->prepare($string);

    $sth_insert->execute($id, '', '', '');

}

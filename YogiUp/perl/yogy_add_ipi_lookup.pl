#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use DBI;

my ($file, $MYSQL, $DATABASE, $HOST, $PORT, $USER, $PASSWD) = @ARGV;
my $dbh = connect_to_DB($MYSQL, $DATABASE, $HOST, $PORT, '', $USER, $PASSWD);

sub getSpecies{
    my $filename = $_[0];
    my %file_species = ('ARATH.xrefs' => 10,
        'HUMAN.xrefs' => 40,
        'BRARE.xrefs' => 100,
        'CHICK.xrefs' => 120,
        'MOUSE.xrefs' => 130,
        'RAT.xrefs'   => 150,
        'BOVIN.xrefs' => 280);

    foreach my $i (keys %file_species){
        if(index($filename, $i) != -1 ){
            return $file_species{$i};
        }
    }
    die "cannot find the corresponding specie through file name";
}


open(IPI, $file)
    or die "Couldn't open file $file: $!";
my $tmp = <IPI>;
while (defined (my $line = <IPI>) ) {
    chomp $line;
    insert_ipi_lines(getSpecies($file), $line);
}

close(IPI);
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


sub insert_ipi_lines {

    my $species_id = shift;
    my $line       = shift;

    my @array = split /\t/, $line;

    my $arr_diff_len = 17 - scalar @array;

    for (my $i = 0; $i < $arr_diff_len; $i++) {

        push @array, '';

    }

    #print "\n\n\n[", scalar @array, "]\n";
    #print "[$_]\n" foreach @array;
    #return;

    my $insert = qq(INSERT IGNORE INTO ipi_lookup (species_id,
    DB_name,
    DB_id,
    IPI_id,
    ALT_USP_id,
    ALT_UTR_id,
    ALT_ENS_id,
    ALT_RS_id,
    ALT_TAIR_id,
    ALT_HINV_id,
    EMBL_acc,
    MO_DB_id,
    NCBI_gene_id,
    UNIPARC_id,
    UniGene_id,
    CCDS_id,
    RS_GI_PI_id,
    ALT_VEGA_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    );

    my $sth = $dbh->prepare($insert)
        or die "Can't prepare: $DBI::errstr\n";

    $sth->execute($species_id, @array)
        or warn "Can't execute: $DBI::errstr\n";

}

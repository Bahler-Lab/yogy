#!/usr/local/perl

use strict;

my $file = shift;

open FILE, $file
    or die "Cannot open file $file: $!";

local $/ = "//\n";

while (<FILE>) {

    my @field = split /\n/;

    undef my $name;
    undef my @acc;

    undef my $embl_acc;
    undef my $embl_id;

    foreach my $field (@field) {

        my $type = substr $field, 0, 2;

        next
            unless $type eq 'ID' or
                   $type eq 'AC' or
                   $type eq 'DR';

        #print "[$field]\n";

        if ($type eq 'ID') {

            ($name) = substr($field, 5) =~ /^(\S+)/;

        } elsif ($type eq 'AC') {

            (@acc) = split /; ?/, substr($field, 5);

        } elsif ($type eq 'DR') {

            next unless substr($field, 5, 6) eq 'EMBL; ';

            ($embl_acc, $embl_id) = substr($field, 11) =~ /^([^;]+); ([^;]+); /;

        }

    }

    my $acc = join ';', @acc;

    print "$name\t$acc\t$embl_acc\t$embl_id\n"
        if defined $embl_acc;

#    print "FIELD: [$_]\n"
#        if not defined $name;

}

close FILE
    or die "Cannot close file $file: $!";

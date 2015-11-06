#!/usr/local/bin/perl
##!/usr/bin/perl
#
# $Id: webget,v 1.2 2000/01/14 16:27:03 cpenkett Exp cpenkett $
#
# webget - A perl script designed to act as a web-client
#
# Author: Chris Penkett
# Date: 14 January 2000
#
#:   webget [options] [-a web-address] [-f url-file]
#:
#:     -h: Shows Usage
#:     -a: Web address
#:     -f: File with list of URLs
#:     -P: Proxy address
#:     -u: Proxy username
#:     -p: Supply a proxy password on the command line
#:
#
# $Author: cpenkett $
# $Date: 2000/01/14 16:27:03 $
# $Revision: 1.2 $
# $RCSfile: webget,v $
#
# $Log: webget,v $
# Revision 1.2  2000/01/14 16:27:03  cpenkett
# *** empty log message ***
#
# Revision 1.1  2000/01/14 16:25:04  cpenkett
# Initial revision
#

require 5.004;                          # Use recent version of Perl

use LWP::UserAgent;                     # LWP version for dealing withproxies etc.
#use HTTP::Request;
#use HTTP::Response;
use HTML::Parser;
use File::Basename;                     # For filename pieces
use Getopt::Std;                        # Command-line options
use strict;                             # Write solid code

my $VERSION;
($VERSION) = (q$Revision: 1.2 $ =~ /[.\d]+/g); # Version control

my ($fnSelf,
    $dirSelf,
    $web_address,
    $url_file,
    $proxy,
    $username,
    $password,
    $addressline,
    $address,
    $request,
    $response,
    $html
);

#----------------
# Initialization

BEGIN {
  $fnSelf = basename($0);
  $dirSelf = dirname($0);
} # BEGIN

#--------------
# Main Program
#--------------

my %Opts = ();                          # A hash of options

if (!&getopts("ha:f:P:pu:", \%Opts) || $Opts{h}) {
    &ShowUsage;
    exit(-1);
}

# Command line variables
if ($Opts{a}) {
    $web_address = $Opts{a};
} elsif ($Opts{f}) {
    $url_file = $Opts{f};
}

if ($Opts{P}) {
    $proxy = $Opts{P};
    $username = $Opts{u};
}

if ($Opts{p}) {
    print STDERR "Enter password: ";
    system "stty", "-echo";
    $password = <STDIN>;
    system "stty", "echo";
}

my $ua = new LWP::UserAgent;            # Main web-client object

if ($Opts{P}) {
    # Proxy address
    $ua->proxy(['http', 'ftp'] => $proxy);
    # Proxy exceptions
    $ua->no_proxy('rpr0698', 'drcsg13', 'drcsg14', 'cvas92'); 
}

if ($Opts{a}) {
    getRequest($web_address);
} elsif ($Opts{f}) {
    open URLFILE, $Opts{f} or die "Can't open file $Opts{f}: $!";
    while ($addressline = <URLFILE>) {
      getRequest($addressline);
    }
}

sub getRequest {
    $address = $_[0];

    # This works for cvas92 with my Incyte username and password
    # $request = new HTTP::Request('GET', 'http://cpenkett:chris@cvas92/');

    # Do a request for the web-page
    $request = HTTP::Request->new('GET', $address);
    if ($Opts{P}) {
        $request->proxy_authorization_basic($username, $password);
    }

    # Get the response
    $response = $ua->request($request);

    print "$address\n\n";
    if ($response->is_success) {        # Test if response is OK
        $html = $response->as_string;
    } else {
        $html = $response->error_as_HTML;
    }
    $html =~ s/<[^>]*>//g;
    print $html;
}

#------------------------
# Subroutine - ShowUsage
#------------------------

sub ShowUsage {
    print STDERR "\n", $fnSelf, " (v $VERSION)\n\n";
    print STDERR "$fnSelf ERROR: ",join(' ', @_),"\n" if (defined $_[0]);
    print STDERR `egrep "^#:" $fnSelf | cut -c3-`;
    exit -1;
} # ShowUsage


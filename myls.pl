#!/usr/bin/perl

use strict;

if ($ARGV[1]) {
    print "Error only one directory allowed.\n";
    exit;
}

my $dir = "./";

$dir = $ARGV[0] if defined $ARGV[0];

print "Directory: $dir\n";




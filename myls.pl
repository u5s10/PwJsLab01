#!/usr/bin/perl

use strict;

my $dir = "./";
my $LFlag = 0;
my $lFlag = 0;

foreach my $var(@ARGV){
    if (($var =~ /-.n*([^lL])/)) {
	print "myls: invalid option $1.\n";
	exit;
    }
    if(($var =~ /-.*[l]/)){
	$lFlag = 1;
    }
    if(($var =~ /-.*[L]/)){
	$LFlag = 1;
    }
    if(($var =~ /^[^-].+/)){
	$dir = $var;
    }
}
print "Lflag:$LFlag\nlFlag:$lFlag\ndir:$dir\n";


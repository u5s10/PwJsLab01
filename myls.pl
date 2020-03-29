#!/usr/bin/perl

use strict;
use File::stat;
use Stat::lsMode;
use POSIX qw(strftime);

my $dir = "./"; #deafult dir
my $LFlag = 0; #name of the owner of the file
my $lFlag = 0; #name of the file, size, modify date, permissons

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
    if(($var =~ /^[^-].*/)){
	$dir = $var;
    }
}

print "Lflag:$LFlag\nlFlag:$lFlag\ndir:$dir\n\n";

opendir(my $dh, $dir) || die "Can't opendir $dir: $!";
my @dots = grep {/^[^.].*/ && "$dir/$_"} readdir($dh);
foreach my $thing (sort @dots){
    my $sb = stat("$dir/$thing");
    my $time = strftime  "%Y-%m-%d %H:%M:%S", localtime $sb->mtime;
    my $size = $sb->size;
    my $mode = $sb->mode;
    my $lsmode = file_mode("$dir/$thing");
    my $ownername = getpwuid((stat("$dir/$thing"))[4]);

    print "$thing\t$size\t$time\t$lsmode\t$ownername\n";
}
closedir $dh;

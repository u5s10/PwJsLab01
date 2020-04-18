#!/usr/bin/perl
use strict;
use File::stat;
use Fcntl ':mode';
use User::pwent;
use POSIX qw(strftime);

my $dir = "./"; #deafult dir
my $LFlag = 0; #name of the owner of the file
my $lFlag = 0; #name of the file, size, modify date, permissons

foreach my $var(@ARGV){ #checking for flags
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

opendir(my $dh, $dir) || die "Can't opendir $dir: $!";
my @dots = grep {/^[^.].*/ && "$dir/$_"} readdir($dh);

foreach my $thing (sort @dots){
    my $sb = stat("$dir/$thing");
    my $time = strftime  "%Y-%m-%d %H:%M:%S", localtime $sb->mtime; 
    my $size = $sb->size;
    my $mode = $sb->mode;
    my $pwattrs = getpwuid($sb->uid);
    my $ownername = $pwattrs->name;
    my $temp = sprintf ("%03o", $mode & 07777); 
    my $lsStyleMode = "";    
    my $bin = "";

    if(S_ISDIR($mode)){
	$lsStyleMode .= "d"
    }else{
	$lsStyleMode .= "-"
    }

    for (my $var = 0; $var < length($temp); $var++) {
	my $s = substr($temp,$var,1);
	my $bintemp = sprintf("%.3b",$s);
	$bin .= $bintemp;
    }

    my $lsModeTemplate = "rwxrwxrwx";
    for (my $var = 0; $var < length($bin); $var++) {
	if(substr($bin,$var,1)){
	    $lsStyleMode .= substr($lsModeTemplate,$var,1);
	}else{
	    $lsStyleMode .= "-";
	}
    }
    
    if(($lFlag == 1) && ($LFlag ==1)){
	printf ("%-30s %-10s %-19s %-10s %-10s\n",$thing, $size, $time, $lsStyleMode, $ownername);	
    }elsif(($lFlag == 1) && ($LFlag ==0)){
	printf ("%-30s %-10s %-19s %-10s\n",$thing, $size, $time, $lsStyleMode);	
    }elsif(($lFlag == 0) && ($LFlag ==1)){
	printf ("%-30s %-10s\n",$thing, $ownername);	
    }else{
	printf ("%-30s\n",$thing);	
    }
}
closedir $dh;

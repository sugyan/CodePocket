#!/opt/local/bin/perl
use strict;
use warnings;

my $out;

open TEMPOUT, '>&STDOUT';
close STDOUT;
open STDOUT, '>', \$out;

print TEMPOUT "temp!";
print "hoge\n";
print "fuga\n";
print "piyo\n";

close STDOUT;
open STDOUT, '>&TEMPOUT';
close TEMPOUT;

$out = scalar reverse $out;

print $out, "\n";

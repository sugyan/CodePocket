#!/opt/local/bin/perl
use strict;
use warnings;

use IO::Capture::Stdout;

my $capture = IO::Capture::Stdout->new;

$capture->start;
print "hoge";
print "fuga";
print "piyo";
$capture->stop;

for my $line (reverse $capture->read) {
    print $line, "\n";
}

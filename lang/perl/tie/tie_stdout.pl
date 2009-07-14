#!/opt/local/bin/perl
use strict;
use warnings;

use Tie::STDOUT print => sub {
    print join " ", map { $_ x 2 } @_;
    print "\n";
};

print 'ほげ', 'ふが', 'ぴよ';

syswrite STDOUT, "大事なことなので２回ずつ言いました\n";

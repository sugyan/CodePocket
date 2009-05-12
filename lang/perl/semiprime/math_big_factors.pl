#!/opt/local/bin/perl
use strict;
use warnings;

use Math::Big::Factors qw(factors_wheel);

for my $num (1..99) {
    my @factors = factors_wheel($num);
    print "$num\n" if scalar(@factors) == 2;
}

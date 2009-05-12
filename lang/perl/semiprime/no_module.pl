#!/usr/bin/perl
use strict;
use warnings;

# 最小の素因数を返すサブルーチン
# 引数が素数だった場合はundefを返す
sub get_factor {
    my $target = shift;
    for my $num (2 .. $target-1) {
        if ($target % $num == 0) {
            return $num;
        }
    }
    return;
}

TARGET: for my $num (1..99) {
    my $first_factor = get_factor($num);
    if (!defined($first_factor)) {
        next TARGET;
    }

    my $second_factor = get_factor($num / $first_factor);
    if (!defined($second_factor)) {
        print "$num\n";
    }
}

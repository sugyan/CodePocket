#!/opt/local/bin/perl
use strict;
use warnings;

use Coro;
use Coro::AnyEvent;

my $cv = AnyEvent->condvar;
async {
    my $count = 0;
    until (++$count > 30) {
        Coro::AnyEvent::sleep rand(0.5);
        print $Coro::current, " : $count\n";
        cede;
    }
    $cv->send;
};
async {
    while (1) {
        print $Coro::current, "\n";
        Coro::AnyEvent::sleep 1;
        cede;
    }
};

$cv->recv;

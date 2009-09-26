#!/opt/local/bin/perl
use strict;
use warnings;

use AnyEvent;
use Term::ReadKey;
ReadMode 4;

my $cv_timer = AnyEvent->condvar;
my $timer; $timer = AnyEvent->timer(
    after    => 0,
    interval => 1,
    cb       => sub {
        print AnyEvent->time, "\n";
        $cv_timer->send;
    },
);
$cv_timer->recv;

while (1) {
    my $cv = AnyEvent->condvar;
    my $io; $io = AnyEvent->io(
        fh   => \*STDIN,
        poll => 'r',
        cb   => sub {
            my $key;
            while (!defined($key = ReadKey(-1))) {
            }
            undef $io;
            $cv->send($key);
        },
       );
    if (defined(my $input = $cv->recv)) {
        last if $input eq 'q';
        print "got: [$input]\n";
    }
}

ReadMode 0;
undef $timer;


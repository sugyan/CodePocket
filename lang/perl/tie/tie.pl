#!/opt/local/bin/perl
use strict;
use warnings;

my $hoge;
{
    $hoge = tie local *STDOUT, 'Hoge';
    print "hoge";
    print "fuga";
    print "piyo";
}

for my $line ($hoge->lines) {
    print "$line\n";
}


package Hoge;

sub TIEHANDLE {
    my $class = shift;
    my @lines;
    bless \@lines, $class;
}

sub PRINT {
    my $self = shift;
    for my $arg (@_) {
        push(@$self, qq['$arg'が書かれたよ]);
    }
}

sub lines {
    my $self = shift;
    return @$self;
}

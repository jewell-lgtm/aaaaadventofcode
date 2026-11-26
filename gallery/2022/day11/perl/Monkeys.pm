# Shared: one hash per monkey, captured from each paragraph by a single /x regex.
package Monkeys;
use strict;
use warnings;
use List::Util qw(product);

sub parse {
    my ($input) = @_;
    my @monkeys;
    while ($input =~ m{
        Starting\ items:\ ([\d,\ ]+) \n
        \s+ Operation:\ new\ =\ old\ (.)\ (\w+) \n
        \s+ Test:\ divisible\ by\ (\d+) \n
        \s+ If\ true:\ throw\ to\ monkey\ (\d+) \n
        \s+ If\ false:\ throw\ to\ monkey\ (\d+)
    }xg) {
        my ($sym, $rhs) = ($2, $3);
        push @monkeys, {
            items   => [ split /,\s*/, $1 ],
            op      => sub { my $v = $rhs eq 'old' ? $_[0] : $rhs; $sym eq '*' ? $_[0] * $v : $_[0] + $v },
            divisor => $4,
            targets => [ $6, $5 ],    # indexed by "is divisible"
            seen    => 0,
        };
    }
    return @monkeys;
}

sub business {
    my ($rounds, $relieve, @monkeys) = @_;
    for (1 .. $rounds) {
        for my $m (@monkeys) {
            for my $item (@{ $m->{items} }) {
                my $worry = $relieve->($m->{op}->($item));
                push @{ $monkeys[ $m->{targets}[ $worry % $m->{divisor} == 0 ] ]{items} }, $worry;
            }
            $m->{seen} += @{ $m->{items} };
            $m->{items} = [];
        }
    }
    my ($a, $b) = sort { $b <=> $a } map { $_->{seen} } @monkeys;
    return $a * $b;
}

sub divisor_product { product map { $_->{divisor} } @_ }

1;

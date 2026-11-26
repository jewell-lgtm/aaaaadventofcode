# Shared: Dijkstra with a bucket queue (weights 1..9) over flat indices r * W + c.
package Chiton;
use strict;
use warnings;
use integer;

sub lowest_risk {
    my ($input, $tiles) = @_;
    my @base = map { [ split // ] } split /\n/, $input;
    my ($h, $w) = (scalar @base, scalar @{ $base[0] });
    my ($H, $W) = ($h * $tiles, $w * $tiles);
    my $risk = sub { my ($r, $c) = @_; ($base[ $r % $h ][ $c % $w ] + $r / $h + $c / $w - 1) % 9 + 1 };

    my @dist = (0);
    my @buckets = ([ [ 0, 0 ] ]);
    for (my $d = 0; $d < @buckets; $d++) {
        for my $p (@{ $buckets[$d] || [] }) {
            my ($r, $c) = @$p;
            next if $dist[ $r * $W + $c ] < $d;
            return $d if $r == $H - 1 && $c == $W - 1;
            for ([ $r + 1, $c ], [ $r - 1, $c ], [ $r, $c + 1 ], [ $r, $c - 1 ]) {
                my ($nr, $nc) = @$_;
                next if $nr < 0 || $nc < 0 || $nr >= $H || $nc >= $W;
                my $nd = $d + $risk->($nr, $nc);
                my $old = $dist[ $nr * $W + $nc ];
                next if defined $old && $old <= $nd;
                $dist[ $nr * $W + $nc ] = $nd;
                push @{ $buckets[$nd] }, [ $nr, $nc ];
            }
        }
    }
    die "unreachable\n";
}

1;

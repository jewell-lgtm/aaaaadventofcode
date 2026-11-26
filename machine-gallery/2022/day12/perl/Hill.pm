# Shared: grid as an array of char arrays, BFS with an array used as a queue.
package Hill;
use strict;
use warnings;

sub height { my $ch = shift; ord($ch eq 'S' ? 'a' : $ch eq 'E' ? 'z' : $ch) }

sub shortest_path {
    my ($input, $start_re) = @_;
    my @grid = map { [ split // ] } split /\n/, $input;
    my (@queue, %dist);
    for my $r (0 .. $#grid) {
        for my $c (0 .. $#{ $grid[$r] }) {
            next unless $grid[$r][$c] =~ $start_re;
            push @queue, [ $r, $c ];
            $dist{"$r,$c"} = 0;
        }
    }
    while (my $p = shift @queue) {
        my ($r, $c) = @$p;
        my $steps = $dist{"$r,$c"};
        return $steps if $grid[$r][$c] eq 'E';
        for ([ 1, 0 ], [ -1, 0 ], [ 0, 1 ], [ 0, -1 ]) {
            my ($nr, $nc) = ($r + $_->[0], $c + $_->[1]);
            next if $nr < 0 || $nc < 0 || $nr > $#grid || $nc > $#{ $grid[$nr] };
            next if exists $dist{"$nr,$nc"};
            next if height($grid[$nr][$nc]) - height($grid[$r][$c]) > 1;
            $dist{"$nr,$nc"} = $steps + 1;
            push @queue, [ $nr, $nc ];
        }
    }
    die "no path\n";
}

1;

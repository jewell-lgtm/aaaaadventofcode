# Shared: bottom-up DP from the end of the row: ways[i][g] = arrangements of row[i..] using groups[g..].
package Springs;
use strict;
use warnings;

sub arrangements {
    my ($row, @groups) = @_;
    my ($n, $m) = (length $row, scalar @groups);
    my @ways;
    $ways[$n + 1][$_] = $ways[$n][$_] = ($_ == $m ? 1 : 0) for 0 .. $m;
    for my $i (reverse 0 .. $n - 1) {
        my $c = substr $row, $i, 1;
        for my $g (0 .. $m) {
            my $w = $c ne '#' ? $ways[ $i + 1 ][$g] : 0;
            if ($c ne '.' && $g < $m) {
                my $size = $groups[$g];
                $w += $ways[ $i + $size + 1 ][ $g + 1 ]
                    if $i + $size <= $n
                    && index(substr($row, $i, $size), '.') < 0
                    && substr($row . '.', $i + $size, 1) ne '#';
            }
            $ways[$i][$g] = $w;
        }
    }
    return $ways[0][0];
}

sub total {
    my ($input, $copies) = @_;
    my $total = 0;
    for (split /\n/, $input) {
        my ($row, $groups) = split;
        $total += arrangements(join('?', ($row) x $copies), (split /,/, $groups) x $copies);
    }
    return $total;
}

1;

# Supply Stacks, part 1: arrays as stacks, crates moved one at a time.
# Perl: splice removes the top n, reverse models single-crate moves.
package Part1;
use strict;
use warnings;
use Stacks;

sub solve {
    my ($stacks, $moves) = Stacks::parse($_[0]);
    for (@$moves) {
        my ($n, $from, $to) = @$_;
        push @{ $stacks->[$to] }, reverse splice @{ $stacks->[$from] }, -$n;
    }
    return Stacks::tops($stacks);
}

1;

# Supply Stacks, part 2: the whole slice moves at once, order preserved.
# Perl: part 1 minus the reverse.
package Part2;
use strict;
use warnings;
use Stacks;

sub solve {
    my ($stacks, $moves) = Stacks::parse($_[0]);
    for (@$moves) {
        my ($n, $from, $to) = @$_;
        push @{ $stacks->[$to] }, splice @{ $stacks->[$from] }, -$n;
    }
    return Stacks::tops($stacks);
}

1;

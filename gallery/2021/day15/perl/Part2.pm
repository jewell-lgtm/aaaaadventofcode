# Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
# Perl: a closure computes tiled risk; `use integer` makes / an integer division.
package Part2;
use strict;
use warnings;
use Chiton;

sub solve { Chiton::lowest_risk($_[0], 5) }

1;

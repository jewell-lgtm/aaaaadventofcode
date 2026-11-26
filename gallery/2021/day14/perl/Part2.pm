# Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
# Perl: counts (~1e13) stay exact as 64-bit integers.
package Part2;
use strict;
use warnings;
use Polymer;

sub solve { Polymer::spread($_[0], 40) }

1;

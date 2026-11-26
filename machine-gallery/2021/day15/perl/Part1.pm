# Chiton, part 1: Dijkstra from top-left to bottom-right.
# Perl: no heap in core, so an array of buckets indexed by distance; autovivification creates them.
package Part1;
use strict;
use warnings;
use Chiton;

sub solve { Chiton::lowest_risk($_[0], 1) }

1;

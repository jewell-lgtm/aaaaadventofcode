# Hill Climbing Algorithm, part 1: BFS from S to E.
# Perl: a hash keyed by "r,c" strings stores distances and doubles as the visited set.
package Part1;
use strict;
use warnings;
use Hill;

sub solve { Hill::shortest_path($_[0], qr/S/) }

1;

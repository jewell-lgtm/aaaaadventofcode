# Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
# Perl: the start set is just a regex over cell characters.
package Part2;
use strict;
use warnings;
use Hill;

sub solve { Hill::shortest_path($_[0], qr/[Sa]/) }

1;

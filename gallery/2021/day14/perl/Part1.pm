# Extended Polymerization, part 1: 10 steps, then most common minus least common element.
# Perl: a list-context regex match builds the whole rule hash in one line.
package Part1;
use strict;
use warnings;
use Polymer;

sub solve { Polymer::spread($_[0], 10) }

1;

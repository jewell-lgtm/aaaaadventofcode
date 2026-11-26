# Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
# Perl: the list-repetition operator (LIST) x 5 does the unfolding.
package Part2;
use strict;
use warnings;
use Springs;

sub solve { Springs::total($_[0], 5) }

1;

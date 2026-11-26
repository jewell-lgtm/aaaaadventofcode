# Hot Springs, part 1: count arrangements per row with a DP table filled right to left.
# Perl: substr/index for the window checks; the table is an array of arrays.
package Part1;
use strict;
use warnings;
use Springs;

sub solve { Springs::total($_[0], 1) }

1;

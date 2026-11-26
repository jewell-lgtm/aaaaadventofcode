# Camel Cards, part 1: encode type + card ranks into one string and sort with cmp.
# Perl: the map-sort-map pipeline (Schwartzian transform) is the classic custom-sort idiom.
package Part1;
use strict;
use warnings;
use Cards;

sub solve { Cards::winnings($_[0], '23456789TJQKA', 0) }

1;

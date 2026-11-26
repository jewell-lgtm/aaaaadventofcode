# Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
# Perl: delete on a hash returns the removed value, here the joker count.
package Part2;
use strict;
use warnings;
use Cards;

sub solve { Cards::winnings($_[0], 'J23456789TQKA', 1) }

1;

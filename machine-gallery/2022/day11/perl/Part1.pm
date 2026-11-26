# Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
# Perl: an /x regex documents the record layout; closures capture each operation.
package Part1;
use strict;
use warnings;
use Monkeys;

sub solve { Monkeys::business(20, sub { int($_[0] / 3) }, Monkeys::parse($_[0])) }

1;

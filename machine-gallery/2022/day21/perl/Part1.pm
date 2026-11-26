# Monkey Math, part 1: recursively evaluate the expression tree from root.
# Perl: `ref $job` tells leaves from operator nodes; a hash of code refs does the arithmetic.
package Part1;
use strict;
use warnings;
use MonkeyMath;

sub solve { sprintf '%.0f', MonkeyMath::evaluate(MonkeyMath::parse($_[0]), 'root') }

1;

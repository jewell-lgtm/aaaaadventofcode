# Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
# Perl: values stay below modulus^2 (~1e14), safely inside a 64-bit integer.
package Part2;
use strict;
use warnings;
use Monkeys;

sub solve {
    my @monkeys = Monkeys::parse($_[0]);
    my $modulus = Monkeys::divisor_product(@monkeys);
    return Monkeys::business(10_000, sub { $_[0] % $modulus }, @monkeys);
}

1;

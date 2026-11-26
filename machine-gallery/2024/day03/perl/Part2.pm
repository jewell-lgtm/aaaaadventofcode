# Mull It Over, part 2: strip every don't()...do() span with s///gs, then reuse part 1.
# Perl: a non-greedy substitution expresses the toggle without any state.
package Part2;
use strict;
use warnings;
use Part1;

sub solve {
    my ($input) = @_;
    (my $active = $input) =~ s/don't\(\).*?(?:do\(\)|\z)//gs;
    return Part1::solve($active);
}

1;

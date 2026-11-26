# Mull It Over, part 1: a global match in list context returns all captures, two at a time.
# Perl: the regex engine is the parser; while (//g) walks every match.
package Part1;
use strict;
use warnings;

sub solve {
    my ($input) = @_;
    my $total = 0;
    $total += $1 * $2 while $input =~ /mul\((\d{1,3}),(\d{1,3})\)/g;
    return $total;
}

1;

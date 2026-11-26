# Report Repair, part 1: one pass, remembering seen numbers in a hash.
# Perl: the hash-as-set idiom and a statement-modifier return.
package Part1;
use strict;
use warnings;

sub solve {
    my ($input) = @_;
    my %seen;
    for my $n (split ' ', $input) {
        return $n * (2020 - $n) if $seen{ 2020 - $n };
        $seen{$n} = 1;
    }
    die "no pair sums to 2020\n";
}

1;

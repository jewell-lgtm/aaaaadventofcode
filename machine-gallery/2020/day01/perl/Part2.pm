# Report Repair, part 2: two nested loops plus a hash lookup for the third number.
# Perl: index ranges and the hash-as-set idiom keep it O(n^2).
package Part2;
use strict;
use warnings;

sub solve {
    my ($input) = @_;
    my @nums = split ' ', $input;
    my %index = map { $nums[$_] => $_ } 0 .. $#nums;
    for my $i (0 .. $#nums) {
        for my $j ($i + 1 .. $#nums) {
            my $c = 2020 - $nums[$i] - $nums[$j];
            my $k = $index{$c};
            return $nums[$i] * $nums[$j] * $c if defined $k && $k > $j;
        }
    }
    die "no triple sums to 2020\n";
}

1;

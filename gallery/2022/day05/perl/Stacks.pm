# Shared parser: walk the drawing bottom-up, pushing the letter at column 1 + 4i onto stack i.
package Stacks;
use strict;
use warnings;
use List::Util qw(max);

sub parse {
    my ($input) = @_;
    my ($drawing, $procedure) = split /\n\n/, $input;
    my @rows = split /\n/, $drawing;
    pop @rows;    # stack labels
    my @stacks;
    for my $row (reverse @rows) {
        while ($row =~ /\[(\w)\]/g) {
            push @{ $stacks[ (pos($row) - 3) / 4 ] }, $1;
        }
    }
    my @moves = map { [ $_->[0], $_->[1] - 1, $_->[2] - 1 ] }
                map { [ /(\d+)/g ] } grep { /\S/ } split /\n/, $procedure;
    return (\@stacks, \@moves);
}

sub tops { join '', map { $_->[-1] } @{ $_[0] } }

1;

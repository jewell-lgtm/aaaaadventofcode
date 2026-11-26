# Shared: precompute a sortable string key per hand, then a plain string sort (Schwartzian-style).
package Cards;
use strict;
use warnings;

sub key {
    my ($hand, $order, $jokers) = @_;
    my %count;
    $count{$_}++ for split //, $hand;
    my $wild = $jokers ? delete $count{J} // 0 : 0;
    my @groups = sort { $b <=> $a } values %count;
    @groups = (0) unless @groups;    # all jokers
    $groups[0] += $wild;
    my $type  = join '', @groups, 0 x (5 - @groups);
    my $ranks = join '', map { chr(ord('a') + index $order, $_) } split //, $hand;
    return "$type$ranks";
}

sub winnings {
    my ($input, $order, $jokers) = @_;
    my @ranked = map  { $_->[1] }
                 sort { $a->[0] cmp $b->[0] }
                 map  { my ($hand, $bid) = split; [ key($hand, $order, $jokers), $bid ] }
                 split /\n/, $input;
    my $total = 0;
    $total += ($_ + 1) * $ranked[$_] for 0 .. $#ranked;
    return $total;
}

1;

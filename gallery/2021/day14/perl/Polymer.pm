# Shared: a hash of pair counts; each rule AB -> C turns every AB into AC + CB.
package Polymer;
use strict;
use warnings;
use List::Util qw(min max);

sub spread {
    my ($input, $steps) = @_;
    my ($template, $rules_block) = split /\n\n/, $input;
    my %rule = $rules_block =~ /(\w\w) -> (\w)/g;
    my %pairs;
    $pairs{ substr $template, $_, 2 }++ for 0 .. length($template) - 2;

    for (1 .. $steps) {
        my %next;
        while (my ($pair, $n) = each %pairs) {
            if (my $c = $rule{$pair}) {
                $next{ substr($pair, 0, 1) . $c } += $n;
                $next{ $c . substr($pair, 1) } += $n;
            }
            else { $next{$pair} += $n }
        }
        %pairs = %next;
    }

    my %elements = (substr($template, -1) => 1);
    $elements{ substr $_, 0, 1 } += $pairs{$_} for keys %pairs;
    return max(values %elements) - min(values %elements);
}

1;

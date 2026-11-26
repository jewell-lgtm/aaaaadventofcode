# Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
# inverting each operation against the value of the other (known) branch.
package Part2;
use strict;
use warnings;
use MonkeyMath;

my %INVERT_LEFT  = ('+' => '-', '-' => '+', '*' => '/', '/' => '*');    # x op k = t  =>  x = t inv k

sub solve_for {
    my ($tree, $name, $target) = @_;
    return $target if $name eq 'humn';
    my ($left, $op, $right) = @{ $tree->{$name} };
    if (MonkeyMath::depends_on($tree, $left)) {
        my $known = MonkeyMath::evaluate($tree, $right);
        return solve_for($tree, $left, $MonkeyMath::OP{ $INVERT_LEFT{$op} }->($target, $known));
    }
    my $known = MonkeyMath::evaluate($tree, $left);
    # k op x = t:  + and * invert as before; - and / swap operands
    my $next = $op =~ m{[-/]} ? $MonkeyMath::OP{$op}->($known, $target)
                              : $MonkeyMath::OP{ $INVERT_LEFT{$op} }->($target, $known);
    return solve_for($tree, $right, $next);
}

sub solve {
    my $tree = MonkeyMath::parse($_[0]);
    $tree->{root}[1] = '-';
    return sprintf '%.0f', solve_for($tree, 'root', 0);
}

1;

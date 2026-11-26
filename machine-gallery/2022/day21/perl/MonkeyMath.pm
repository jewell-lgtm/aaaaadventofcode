# Shared: a hash of name => number | [left, op, right]; a dispatch table maps operators to subs.
package MonkeyMath;
use strict;
use warnings;

our %OP = (
    '+' => sub { $_[0] + $_[1] },
    '-' => sub { $_[0] - $_[1] },
    '*' => sub { $_[0] * $_[1] },
    '/' => sub { $_[0] / $_[1] },
);

sub parse {
    my ($input) = @_;
    my %tree;
    for (split /\n/, $input) {
        my ($name, $job) = split /: /;
        $tree{$name} = $job =~ /^(\w+) (.) (\w+)$/ ? [ $1, $2, $3 ] : $job;
    }
    return \%tree;
}

sub evaluate {
    my ($tree, $name) = @_;
    my $job = $tree->{$name};
    return $job unless ref $job;
    my ($left, $op, $right) = @$job;
    return $OP{$op}->(evaluate($tree, $left), evaluate($tree, $right));
}

sub depends_on {
    my ($tree, $name) = @_;
    return 1 if $name eq 'humn';
    my $job = $tree->{$name};
    return ref $job && (depends_on($tree, $job->[0]) || depends_on($tree, $job->[2]));
}

1;

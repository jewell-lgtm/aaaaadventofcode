# Harness helpers.
#   example: true when running an example (aoc test).
#   arg('size', 71): example-specific constant from examples.toml `args`, else the default.
package Aoc;
use strict;
use warnings;
use JSON::PP;
use Exporter 'import';
our @EXPORT_OK = qw(example arg);

my $ARGS = decode_json($ENV{AOC_ARGS} || '{}');

sub example { ($ENV{AOC_EXAMPLE} // '') eq '1' }
sub arg { my ($name, $default) = @_; exists $ARGS->{$name} ? $ARGS->{$name} : $default }

1;

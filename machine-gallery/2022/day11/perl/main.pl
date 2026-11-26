# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
use strict;
use warnings;

my $module = ($ENV{AOC_PART} // '1') eq '2' ? 'Part2' : 'Part1';
require "$module.pm";
my $input = do { local $/; <STDIN> };
print $module->can('solve')->($input), "\n";

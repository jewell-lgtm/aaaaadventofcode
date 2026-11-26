<?php
// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
require __DIR__ . '/aoc.php';
$solve = require __DIR__ . (getenv('AOC_PART') === '2' ? '/part2.php' : '/part1.php');
echo $solve(stream_get_contents(STDIN)), "\n";

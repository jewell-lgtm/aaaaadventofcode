<?php
// Supply Stacks, part 2: the CrateMover 9001 moves the slice in one go, order kept.
// PHP: part 1 without array_reverse.
require_once __DIR__ . '/stacks.php';

return function (string $input): string {
    [$stacks, $moves] = parse_stacks($input);
    foreach ($moves as [, $n, $from, $to]) {
        array_push($stacks[$to], ...array_splice($stacks[$from], -$n));
    }
    return tops($stacks);
};

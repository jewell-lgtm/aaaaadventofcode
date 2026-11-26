<?php
// Supply Stacks, part 1: PHP arrays as stacks, crates moved one at a time.
// PHP: array_splice pulls off the top n; array_reverse models single moves.
require_once __DIR__ . '/stacks.php';

return function (string $input): string {
    [$stacks, $moves] = parse_stacks($input);
    foreach ($moves as [, $n, $from, $to]) {
        $crates = array_splice($stacks[$from], -$n);
        array_push($stacks[$to], ...array_reverse($crates));
    }
    return tops($stacks);
};

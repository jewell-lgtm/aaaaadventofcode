<?php
// Mull It Over, part 1: preg_match_all with PREG_SET_ORDER gives one array per match.
// PHP: destructure each match in the foreach header.

return function (string $input): int {
    preg_match_all('/mul\((\d{1,3}),(\d{1,3})\)/', $input, $matches, PREG_SET_ORDER);
    $total = 0;
    foreach ($matches as [, $a, $b]) {
        $total += $a * $b;
    }
    return $total;
};

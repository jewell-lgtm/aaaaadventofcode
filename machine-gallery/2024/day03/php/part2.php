<?php
// Mull It Over, part 2: one alternation, scanned in order, with match() deciding each token.
// PHP: match (true) expressions and list destructuring with defaults.

return function (string $input): int {
    preg_match_all('/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don\'t\(\)/', $input, $matches, PREG_SET_ORDER);
    $enabled = true;
    $total = 0;
    foreach ($matches as $m) {
        match ($m[0]) {
            'do()' => $enabled = true,
            "don't()" => $enabled = false,
            default => $total += $enabled ? $m[1] * $m[2] : 0,
        };
    }
    return $total;
};

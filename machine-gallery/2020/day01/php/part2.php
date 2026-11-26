<?php
// Report Repair, part 2: sort, then a two-pointer sweep for each fixed first entry.
// PHP: sort() in place and plain index arithmetic; O(n^2) without extra memory.

return function (string $input): int {
    $nums = array_map('intval', preg_split('/\s+/', trim($input)));
    sort($nums);
    $n = count($nums);
    for ($i = 0; $i < $n - 2; $i++) {
        [$lo, $hi] = [$i + 1, $n - 1];
        while ($lo < $hi) {
            $sum = $nums[$i] + $nums[$lo] + $nums[$hi];
            if ($sum === 2020) {
                return $nums[$i] * $nums[$lo] * $nums[$hi];
            }
            $sum < 2020 ? $lo++ : $hi--;
        }
    }
    throw new RuntimeException('no triple sums to 2020');
};

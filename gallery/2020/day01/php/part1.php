<?php
// Report Repair, part 1: array_flip turns the list into a hash set; look up complements.
// PHP: isset on array keys is the idiomatic O(1) membership test.

return function (string $input): int {
    $nums = array_map('intval', preg_split('/\s+/', trim($input)));
    $have = array_flip($nums);
    foreach ($nums as $n) {
        if (isset($have[2020 - $n])) {
            return $n * (2020 - $n);
        }
    }
    throw new RuntimeException('no pair sums to 2020');
};

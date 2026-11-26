<?php
// Shared: memoised recursion over (index, group); the memo is a static array keyed "i,g".

function arrangements(string $row, array $groups): int
{
    $memo = [];
    $count = function (int $i, int $g) use (&$count, &$memo, $row, $groups): int {
        if ($i >= strlen($row)) {
            return $g === count($groups) ? 1 : 0;
        }
        if (isset($memo["$i,$g"])) {
            return $memo["$i,$g"];
        }
        $total = $row[$i] !== '#' ? $count($i + 1, $g) : 0;
        $size = $groups[$g] ?? null;
        if ($row[$i] !== '.' && $size !== null
            && $i + $size <= strlen($row)
            && !str_contains(substr($row, $i, $size), '.')
            && ($row[$i + $size] ?? '.') !== '#') {
            $total += $count($i + $size + 1, $g + 1);
        }
        return $memo["$i,$g"] = $total;
    };
    return $count(0, 0);
}

function total_arrangements(string $input, int $copies): int
{
    $total = 0;
    foreach (explode("\n", rtrim($input)) as $line) {
        [$row, $groups] = explode(' ', $line);
        $total += arrangements(
            implode('?', array_fill(0, $copies, $row)),
            array_map('intval', explode(',', implode(',', array_fill(0, $copies, $groups)))),
        );
    }
    return $total;
}

<?php
// Shared parser: str_split each drawing row into 4-char cells; cell[1] is the crate letter.

function parse_stacks(string $input): array
{
    [$drawing, $procedure] = explode("\n\n", rtrim($input, "\n"));
    $rows = explode("\n", $drawing);
    array_pop($rows); // stack labels
    $stacks = [];
    foreach (array_reverse($rows) as $row) {
        foreach (str_split($row, 4) as $i => $cell) {
            if (trim($cell) !== '') {
                $stacks[$i + 1][] = $cell[1];
            }
        }
    }
    ksort($stacks);
    preg_match_all('/move (\d+) from (\d+) to (\d+)/', $procedure, $moves, PREG_SET_ORDER);
    return [$stacks, $moves];
}

function tops(array $stacks): string
{
    return implode('', array_map(fn ($s) => end($s), $stacks));
}

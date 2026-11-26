<?php
// Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
// inverting each operation against the value of the other (known) branch.
require_once __DIR__ . '/monkeys.php';

function solve_for(array $tree, string $name, int|float $target): int|float
{
    if ($name === 'humn') {
        return $target;
    }
    [$left, $op, $right] = $tree[$name];
    if (depends_on_humn($tree, $left)) {
        $known = evaluate($tree, $right);
        return solve_for($tree, $left, match ($op) {
            '+' => $target - $known,
            '-' => $target + $known,
            '*' => $target / $known,
            '/' => $target * $known,
        });
    }
    $known = evaluate($tree, $left);
    return solve_for($tree, $right, match ($op) {
        '+' => $target - $known,
        '-' => $known - $target,
        '*' => $target / $known,
        '/' => $known / $target,
    });
}

return function (string $input): int|string {
    $tree = parse_tree($input);
    $tree['root'][1] = '-';
    return solve_for($tree, 'root', 0);
};

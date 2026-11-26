<?php
// Shared: name => int|[left, op, right]; match expressions evaluate and invert.

function parse_tree(string $input): array
{
    $tree = [];
    foreach (explode("\n", rtrim($input)) as $line) {
        [$name, $job] = explode(': ', $line);
        $parts = explode(' ', $job);
        $tree[$name] = count($parts) === 3 ? $parts : (int) $job;
    }
    return $tree;
}

function apply_op(string $op, int|float $a, int|float $b): int|float
{
    return match ($op) {
        '+' => $a + $b,
        '-' => $a - $b,
        '*' => $a * $b,
        '/' => $a / $b,
    };
}

function evaluate(array $tree, string $name): int|float
{
    $job = $tree[$name];
    if (is_int($job)) {
        return $job;
    }
    [$left, $op, $right] = $job;
    return apply_op($op, evaluate($tree, $left), evaluate($tree, $right));
}

function depends_on_humn(array $tree, string $name): bool
{
    return $name === 'humn'
        || (is_array($tree[$name]) && (depends_on_humn($tree, $tree[$name][0]) || depends_on_humn($tree, $tree[$name][2])));
}

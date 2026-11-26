<?php
// Monkey Math, part 1: recursively evaluate the expression tree from root.
// PHP: `/` returns an int when the division is exact, so values stay integers here.
require_once __DIR__ . '/monkeys.php';

return fn (string $input): int|string => evaluate(parse_tree($input), 'root');

<?php
// Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
// PHP ints are 64-bit, so values below modulus^2 (~1e14) never overflow into floats.
require_once __DIR__ . '/monkeys.php';

return function (string $input): int {
    $monkeys = parse_monkeys($input);
    $modulus = array_product(array_map(fn ($m) => $m->divisor, $monkeys));
    return monkey_business($monkeys, 10_000, fn ($w) => $w % $modulus);
};

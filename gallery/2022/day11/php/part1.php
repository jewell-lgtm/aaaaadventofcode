<?php
// Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
// PHP: constructor promotion + named arguments keep the record parsing readable.
require_once __DIR__ . '/monkeys.php';

return fn (string $input): int => monkey_business(parse_monkeys($input), 20, fn ($w) => intdiv($w, 3));

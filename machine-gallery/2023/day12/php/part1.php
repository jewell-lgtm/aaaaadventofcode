<?php
// Hot Springs, part 1: count arrangements per row by branching on each '?'.
// PHP: a recursive closure needs `use (&$count)` to see itself; the memo is captured by reference.
require_once __DIR__ . '/springs.php';

return fn (string $input): int => total_arrangements($input, 1);

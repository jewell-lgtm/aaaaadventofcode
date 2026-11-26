<?php
// Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
// PHP: array_fill + implode do the unfolding.
require_once __DIR__ . '/springs.php';

return fn (string $input): int => total_arrangements($input, 5);

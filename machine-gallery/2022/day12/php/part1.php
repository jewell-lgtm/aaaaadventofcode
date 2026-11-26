<?php
// Hill Climbing Algorithm, part 1: BFS from S to E.
// PHP: SplQueue for the frontier, "r,c" string keys for the visited map.
require_once __DIR__ . '/hill.php';

return fn (string $input): int => shortest_path($input, 'S');

<?php
// Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
// PHP: same search with 'S' and 'a' as starts.
require_once __DIR__ . '/hill.php';

return fn (string $input): int => shortest_path($input, 'Sa');

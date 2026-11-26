<?php
// Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
// PHP: an arrow function closes over the base grid and computes tiled risk lazily.
require_once __DIR__ . '/chiton.php';

return fn (string $input): int => lowest_risk($input, 5);

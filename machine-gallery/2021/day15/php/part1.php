<?php
// Chiton, part 1: Dijkstra from top-left to bottom-right.
// PHP: SplPriorityQueue from the SPL; insert with -distance to get a min-heap.
require_once __DIR__ . '/chiton.php';

return fn (string $input): int => lowest_risk($input, 1);

<?php
// Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
// PHP: 64-bit ints hold ~1e13 exactly.
require_once __DIR__ . '/polymer.php';

return fn (string $input): int => polymer_spread($input, 40);

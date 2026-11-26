<?php
// Extended Polymerization, part 1: 10 steps, then most common minus least common element.
// PHP: array_combine builds the rule map, array_count_values seeds the pair counter.
require_once __DIR__ . '/polymer.php';

return fn (string $input): int => polymer_spread($input, 10);

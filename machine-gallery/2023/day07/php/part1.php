<?php
// Camel Cards, part 1: count_chars gives the tally, the spaceship operator sorts the keys.
// PHP: <=> on equal-length arrays compares element by element, so no hand-written comparator.
require_once __DIR__ . '/cards.php';

return fn (string $input): int => winnings($input, '23456789TJQKA');

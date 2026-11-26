<?php
// Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
// PHP: same key with the jokers lifted out of the tally.
require_once __DIR__ . '/cards.php';

return fn (string $input): int => winnings($input, 'J23456789TQKA', jokers: true);

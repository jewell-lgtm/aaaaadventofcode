<?php
// Shared: a key of [group sizes, card ranks]; usort with <=>, which compares arrays element-wise.

function hand_key(string $hand, string $order, bool $jokers): array
{
    $counts = count_chars($hand, 1);
    $wild = $jokers ? ($counts[ord('J')] ?? 0) : 0;
    if ($jokers) {
        unset($counts[ord('J')]);
    }
    rsort($counts);
    $groups = array_pad($counts, 5, 0);
    $groups[0] += $wild;
    $ranks = array_map(fn ($c) => strpos($order, $c), str_split($hand));
    return [$groups, $ranks];
}

function winnings(string $input, string $order, bool $jokers = false): int
{
    $hands = array_map(function ($line) use ($order, $jokers) {
        [$hand, $bid] = explode(' ', $line);
        return ['key' => hand_key($hand, $order, $jokers), 'bid' => (int) $bid];
    }, explode("\n", rtrim($input)));
    usort($hands, fn ($a, $b) => $a['key'] <=> $b['key']);
    $total = 0;
    foreach ($hands as $i => $h) {
        $total += ($i + 1) * $h['bid'];
    }
    return $total;
}

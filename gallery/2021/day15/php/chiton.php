<?php
// Shared: Dijkstra with SplPriorityQueue (a max-heap, so priorities are negated).

function lowest_risk(string $input, int $tiles): int
{
    $base = array_map(fn ($row) => array_map('intval', str_split($row)), explode("\n", rtrim($input)));
    [$h, $w] = [count($base), count($base[0])];
    [$H, $W] = [$h * $tiles, $w * $tiles];
    $risk = fn ($r, $c) => ($base[$r % $h][$c % $w] + intdiv($r, $h) + intdiv($c, $w) - 1) % 9 + 1;

    $dist = [0 => 0];
    $queue = new SplPriorityQueue();
    $queue->insert([0, 0], 0);
    while (!$queue->isEmpty()) {
        [$r, $c] = $queue->extract();
        $d = $dist[$r * $W + $c];
        if ($r === $H - 1 && $c === $W - 1) {
            return $d;
        }
        foreach ([[$r + 1, $c], [$r - 1, $c], [$r, $c + 1], [$r, $c - 1]] as [$nr, $nc]) {
            if ($nr < 0 || $nc < 0 || $nr >= $H || $nc >= $W) {
                continue;
            }
            $nd = $d + $risk($nr, $nc);
            if ($nd < ($dist[$nr * $W + $nc] ?? PHP_INT_MAX)) {
                $dist[$nr * $W + $nc] = $nd;
                $queue->insert([$nr, $nc], -$nd);
            }
        }
    }
    throw new RuntimeException('unreachable');
}

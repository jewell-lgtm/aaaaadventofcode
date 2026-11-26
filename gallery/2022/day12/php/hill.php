<?php
// Shared: grid as an array of strings, BFS with SplQueue.

function hill_height(string $ch): int
{
    return ord(['S' => 'a', 'E' => 'z'][$ch] ?? $ch);
}

function shortest_path(string $input, string $starts): int
{
    $grid = explode("\n", rtrim($input, "\n"));
    $queue = new SplQueue();
    $dist = [];
    foreach ($grid as $r => $row) {
        foreach (str_split($row) as $c => $ch) {
            if (str_contains($starts, $ch)) {
                $queue->enqueue([$r, $c]);
                $dist["$r,$c"] = 0;
            }
        }
    }
    while (!$queue->isEmpty()) {
        [$r, $c] = $queue->dequeue();
        $here = $grid[$r][$c];
        if ($here === 'E') {
            return $dist["$r,$c"];
        }
        foreach ([[1, 0], [-1, 0], [0, 1], [0, -1]] as [$dr, $dc]) {
            [$nr, $nc] = [$r + $dr, $c + $dc];
            $there = $grid[$nr][$nc] ?? null;
            if ($nc < 0 || $there === null || isset($dist["$nr,$nc"])) {
                continue;
            }
            if (hill_height($there) - hill_height($here) <= 1) {
                $dist["$nr,$nc"] = $dist["$r,$c"] + 1;
                $queue->enqueue([$nr, $nc]);
            }
        }
    }
    throw new RuntimeException('no path');
}

<?php
// Shared: an array of pair counts; each rule AB -> C turns every AB into AC + CB.

function polymer_spread(string $input, int $steps): int
{
    [$template, $rulesBlock] = explode("\n\n", trim($input));
    preg_match_all('/(\w\w) -> (\w)/', $rulesBlock, $m);
    $rules = array_combine($m[1], $m[2]);

    $pairs = array_count_values(array_map(
        fn ($i) => substr($template, $i, 2),
        range(0, strlen($template) - 2),
    ));

    for ($s = 0; $s < $steps; $s++) {
        $next = [];
        foreach ($pairs as $pair => $n) {
            $c = $rules[$pair] ?? null;
            foreach ($c === null ? [$pair] : [$pair[0] . $c, $c . $pair[1]] as $p) {
                $next[$p] = ($next[$p] ?? 0) + $n;
            }
        }
        $pairs = $next;
    }

    $elements = [$template[-1] => 1];
    foreach ($pairs as $pair => $n) {
        $elements[$pair[0]] = ($elements[$pair[0]] ?? 0) + $n;
    }
    return max($elements) - min($elements);
}

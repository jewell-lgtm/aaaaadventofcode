<?php
// Shared: a small Monkey class with promoted constructor properties, parsed with sscanf-like regexes.

final class Monkey
{
    public int $inspected = 0;

    public function __construct(
        public array $items,
        public Closure $op,
        public int $divisor,
        public int $ifTrue,
        public int $ifFalse,
    ) {
    }

    public static function parse(string $block): self
    {
        $lines = explode("\n", $block);
        $num = fn (string $line): int => (int) preg_replace('/\D/', '', $line);
        preg_match('/old (.) (\w+)/', $lines[2], $m);
        [, $sym, $rhs] = $m;
        return new self(
            items: array_map('intval', explode(', ', explode(': ', $lines[1])[1])),
            op: function (int $old) use ($sym, $rhs): int {
                $v = $rhs === 'old' ? $old : (int) $rhs;
                return $sym === '*' ? $old * $v : $old + $v;
            },
            divisor: $num($lines[3]),
            ifTrue: $num($lines[4]),
            ifFalse: $num($lines[5]),
        );
    }
}

/** @return Monkey[] */
function parse_monkeys(string $input): array
{
    return array_map([Monkey::class, 'parse'], explode("\n\n", trim($input)));
}

function monkey_business(array $monkeys, int $rounds, Closure $relieve): int
{
    for ($round = 0; $round < $rounds; $round++) {
        foreach ($monkeys as $m) {
            foreach ($m->items as $item) {
                $worry = $relieve(($m->op)($item));
                $monkeys[$worry % $m->divisor === 0 ? $m->ifTrue : $m->ifFalse]->items[] = $worry;
            }
            $m->inspected += count($m->items);
            $m->items = [];
        }
    }
    $counts = array_map(fn ($m) => $m->inspected, $monkeys);
    rsort($counts);
    return $counts[0] * $counts[1];
}

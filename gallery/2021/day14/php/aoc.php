<?php
// Harness helpers.
//   Aoc::example(): true when running an example (aoc test).
//   Aoc::arg('size', 71): example-specific constant from examples.toml `args`, else the default.
final class Aoc
{
    public static function example(): bool
    {
        return getenv('AOC_EXAMPLE') === '1';
    }

    public static function arg(string $name, mixed $default): mixed
    {
        static $args = null;
        $args ??= json_decode(getenv('AOC_ARGS') ?: '{}', true);
        return $args[$name] ?? $default;
    }
}

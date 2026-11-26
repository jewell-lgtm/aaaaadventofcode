# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
import std/os
import part1, part2

let input = stdin.readAll()
echo(if getEnv("AOC_PART") == "2": $part2.solve(input) else: $part1.solve(input))

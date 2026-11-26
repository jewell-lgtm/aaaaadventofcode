# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
require "./aoc"
require "./part1"
require "./part2"

input = STDIN.gets_to_end
puts(ENV["AOC_PART"]? == "2" ? Part2.solve(input) : Part1.solve(input))

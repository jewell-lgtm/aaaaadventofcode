# Mull It Over, part 1: String#scan with capture groups yields [a, b] pairs.
# Ruby: scan, map, sum: the regex does the parsing.
require "aoc"

def solve(input)
  input.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum { |a, b| a.to_i * b.to_i }
end

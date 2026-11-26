# Report Repair, part 1: combination(2) then find the pair that sums to 2020.
# Ruby: Enumerable reads left to right: combination, find, then multiply with inject.
require "aoc"

def solve(input)
  input.split.map(&:to_i)
       .combination(2)
       .find { |pair| pair.sum == 2020 }
       .inject(:*)
end

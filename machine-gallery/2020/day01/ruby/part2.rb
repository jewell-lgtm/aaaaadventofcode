# Report Repair, part 2: same chain with combination(3).
# Ruby: combination is lazy-ish (yields), so find stops at the first hit.
require "aoc"

def solve(input)
  input.split.map(&:to_i)
       .combination(3)
       .find { |triple| triple.sum == 2020 }
       .inject(:*)
end

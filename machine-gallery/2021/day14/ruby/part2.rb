# Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
# Ruby: same code; Integers never overflow.
require "aoc"
require "polymer"

def solve(input) = Polymer.spread(input, 40)

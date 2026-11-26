# Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
# Ruby: a lambda computes tiled risk lazily.
require "aoc"
require "chiton"

def solve(input) = Chiton.lowest_risk(input, 5)

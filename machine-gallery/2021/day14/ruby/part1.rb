# Extended Polymerization, part 1: 10 steps, then most common minus least common element.
# Ruby: each_cons(2) + tally seeds the pair counts; each_with_object rebuilds them per step.
require "aoc"
require "polymer"

def solve(input) = Polymer.spread(input, 10)

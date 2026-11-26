# Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
# Julia: Int64 counts hold ~1e13 easily.
using .Aoc: arg, example
include("polymer.jl")

solve(input) = polymer_spread(input, 40)

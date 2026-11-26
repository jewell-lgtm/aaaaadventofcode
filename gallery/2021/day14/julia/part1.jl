# Extended Polymerization, part 1: 10 steps, then most common minus least common element.
# Julia: tuple-of-Char keys, destructuring in for-loops over Dict pairs, extrema for min+max.
using .Aoc: arg, example
include("polymer.jl")

solve(input) = polymer_spread(input, 10)

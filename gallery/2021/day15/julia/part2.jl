# Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
# Julia: a 2D comprehension with mod1 builds the big map in one expression.
using .Aoc: arg, example
include("chiton.jl")

solve(input) = lowest_risk(risk_matrix(input, 5))

# Hot Springs, part 1: count arrangements per row with a DP matrix filled from the end.
# Julia: a zero matrix, reverse ranges and `cond && action` one-liners.
using .Aoc: arg, example
include("springs.jl")

solve(input) = total_arrangements(input, 1)

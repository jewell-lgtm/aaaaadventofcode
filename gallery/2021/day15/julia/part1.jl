# Chiton, part 1: Dijkstra over a risk matrix.
# Julia: no heap in Base; weights are 1..9 so a Dict of distance buckets is simple and fast.
using .Aoc: arg, example
include("chiton.jl")

solve(input) = lowest_risk(risk_matrix(input, 1))

# Hill Climbing Algorithm, part 1: BFS from S to E on a Char matrix.
# Julia: CartesianIndex arithmetic for neighbours, checkbounds for the edges, findall for starts.
using .Aoc: arg, example
include("hill.jl")

solve(input) = shortest_path(input, "S")

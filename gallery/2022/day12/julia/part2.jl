# Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
# Julia: findall(in("Sa"), grid) seeds the queue with all of them.
using .Aoc: arg, example
include("hill.jl")

solve(input) = shortest_path(input, "Sa")

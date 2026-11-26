# Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
# Julia: fill/repeat build the unfolded row and groups; sum(...) do-block sums the rows.
using .Aoc: arg, example
include("springs.jl")

solve(input) = total_arrangements(input, 5)

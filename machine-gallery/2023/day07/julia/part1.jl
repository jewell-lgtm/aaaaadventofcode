# Camel Cards, part 1: type from sorted group sizes, tiebreak by card ranks.
# Julia: sort(...; by = key) with tuples of vectors, which compare lexicographically.
using .Aoc: arg, example
include("cards.jl")

solve(input) = winnings(input, "23456789TJQKA")

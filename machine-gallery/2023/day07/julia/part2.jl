# Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
# Julia: pop!(dict, key, default) takes the jokers out of the tally.
using .Aoc: arg, example
include("cards.jl")

solve(input) = winnings(input, "J23456789TQKA"; jokers = true)

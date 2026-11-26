# Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
# Julia: operators are functions, so (*) and (+) are picked straight from the parsed symbol.
using .Aoc: arg, example
include("monkeys.jl")

solve(input) = business(parse_monkeys(input), 20, w -> w ÷ 3)

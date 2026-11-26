# Monkey Math, part 1: recursively evaluate the expression tree from root.
# Julia: multiple dispatch: one evaluate method per node type (Integer leaf vs Tuple op).
using .Aoc: arg, example
include("monkeys.jl")

solve(input) = Int(evaluate(parse_tree(input), "root"))

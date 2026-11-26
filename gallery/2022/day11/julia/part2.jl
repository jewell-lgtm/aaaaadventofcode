# Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
# Julia: Int64 is plenty once values are kept below modulus^2.
using .Aoc: arg, example
include("monkeys.jl")

function solve(input)
    monkeys = parse_monkeys(input)
    modulus = prod(m.divisor for m in monkeys)
    return business(monkeys, 10_000, w -> w % modulus)
end

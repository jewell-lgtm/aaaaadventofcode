# Supply Stacks, part 2: the slice moves at once, order kept.
# Julia: part 1 without the reverse.
using .Aoc: arg, example
include("stacks.jl")

function solve(input)
    stacks, moves = parse_stacks(input)
    for (n, from, to) in moves
        append!(stacks[to], pop_top!(stacks[from], n))
    end
    return tops(stacks)
end

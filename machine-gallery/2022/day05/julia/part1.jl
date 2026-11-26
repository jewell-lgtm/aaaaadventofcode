# Supply Stacks, part 1: Vector{Char} stacks; crates move one at a time.
# Julia: matrix slicing (grid[:, c]) parses the drawing; splice!/append! move the crates.
using .Aoc: arg, example
include("stacks.jl")

function solve(input)
    stacks, moves = parse_stacks(input)
    for (n, from, to) in moves
        append!(stacks[to], reverse(pop_top!(stacks[from], n)))
    end
    return tops(stacks)
end

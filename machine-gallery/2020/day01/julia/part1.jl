# Report Repair, part 1: a generator over index pairs i < j, stopped by first().
# Julia: comprehensions with dependent ranges read like math; parse.() broadcasts.
using .Aoc: arg, example

function solve(input)
    xs = parse.(Int, split(input))
    n = length(xs)
    pairs = ((xs[i], xs[j]) for i in 1:n for j in i+1:n)
    return prod(first(p for p in pairs if sum(p) == 2020))
end

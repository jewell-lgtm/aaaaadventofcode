# Report Repair, part 2: a generator over index triples i < j < k, stopped by first().
# Julia: multi-dimensional comprehensions with dependent ranges read like math.
using .Aoc: arg, example

function solve(input)
    xs = parse.(Int, split(input))
    n = length(xs)
    triples = ((xs[i], xs[j], xs[k]) for i in 1:n for j in i+1:n for k in j+1:n)
    return prod(first(t for t in triples if sum(t) == 2020))
end

# Mull It Over, part 1: eachmatch with captures, broadcast parse, sum the products.
# Julia: regex literals r"..." and a generator inside sum().
using .Aoc: arg, example

solve(input) = sum(prod(parse.(Int, m.captures)) for m in eachmatch(r"mul\((\d{1,3}),(\d{1,3})\)", input))

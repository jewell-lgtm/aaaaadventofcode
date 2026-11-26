# Mull It Over, part 2: eachmatch over an alternation, folding an (enabled, total) state.
# Julia: foldl with a tuple accumulator and destructuring keeps it pure.
using .Aoc: arg, example

const TOKEN = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

function step((enabled, total), m)
    m.match == "do()" && return (true, total)
    m.match == "don't()" && return (false, total)
    return (enabled, enabled ? total + prod(parse.(Int, m.captures)) : total)
end

solve(input) = last(foldl(step, eachmatch(TOKEN, input); init = (true, 0)))

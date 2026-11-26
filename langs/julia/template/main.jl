# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
include("aoc.jl")
include(get(ENV, "AOC_PART", "1") == "2" ? "part2.jl" : "part1.jl")
println(solve(read(stdin, String)))

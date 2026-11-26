# Harness helpers.
#   Aoc.example: true when running an example (aoc test).
#   Aoc.arg("size", 71): example-specific constant from examples.toml `args`, else the default.
module Aoc

const example = get(ENV, "AOC_EXAMPLE", "") == "1"

# Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS (no JSON in stdlib).
const ARGS = Dict{String,Any}(
    m[1] => something(tryparse(Int, m[2]), tryparse(Float64, m[2]), m[2] == "true" ? true : m[2] == "false" ? false : strip(m[2], '"'))
    for m in eachmatch(r"\"([^\"]+)\"\s*:\s*(\"[^\"]*\"|[^,}\s]+)", get(ENV, "AOC_ARGS", "{}"))
)

arg(name, default) = get(ARGS, name, default)

end

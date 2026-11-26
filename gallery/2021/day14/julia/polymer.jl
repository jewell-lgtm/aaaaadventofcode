# Shared: a Dict of (Char, Char) pair counts; each rule AB -> C turns every AB into AC + CB.
function polymer_spread(input, steps)
    template, rules_block = split(strip(input), "\n\n")
    rules = Dict((l[1], l[2]) => l[end] for l in split(rules_block, '\n'))   # "AB -> C"
    pairs = Dict{Tuple{Char,Char},Int}()
    for p in zip(template, template[2:end])
        pairs[p] = get(pairs, p, 0) + 1
    end
    for _ in 1:steps
        next = Dict{Tuple{Char,Char},Int}()
        for ((a, b), n) in pairs
            c = get(rules, (a, b), nothing)
            for p in (isnothing(c) ? ((a, b),) : ((a, c), (c, b)))
                next[p] = get(next, p, 0) + n
            end
        end
        pairs = next
    end
    counts = Dict(last(template) => 1)
    for ((a, _), n) in pairs
        counts[a] = get(counts, a, 0) + n
    end
    least, most = extrema(values(counts))
    return most - least
end

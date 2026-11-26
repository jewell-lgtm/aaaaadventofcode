# Shared: a hand's key is a tuple (group sizes, card ranks); sortperm orders by it.
function hand_key(hand, order, jokers)
    counts = Dict{Char,Int}()
    for c in hand
        counts[c] = get(counts, c, 0) + 1
    end
    wild = jokers ? pop!(counts, 'J', 0) : 0
    groups = sort!(collect(values(counts)); rev = true)
    isempty(groups) ? push!(groups, wild) : (groups[1] += wild)
    return (groups, [findfirst(c, order) for c in hand])
end

function winnings(input, order; jokers = false)
    hands = split.(split(chomp(input), '\n'))
    ranked = sort(hands; by = h -> hand_key(h[1], order, jokers))
    return sum(rank * parse(Int, bid) for (rank, (_, bid)) in enumerate(ranked))
end

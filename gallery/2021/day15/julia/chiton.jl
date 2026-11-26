# Shared: build the (tiled) risk matrix with broadcasting, then Dijkstra with a bucket queue.
function risk_matrix(input, tiles)
    base = permutedims(reduce(hcat, [parse.(Int, collect(row)) for row in split(chomp(input), '\n')]))
    h, w = size(base)
    return [mod1(base[mod1(r, h), mod1(c, w)] + (r - 1) ÷ h + (c - 1) ÷ w, 9) for r in 1:h*tiles, c in 1:w*tiles]
end

function lowest_risk(risk)
    dist = fill(typemax(Int), size(risk))
    start, goal = first(CartesianIndices(risk)), last(CartesianIndices(risk))
    dist[start] = 0
    buckets = Dict(0 => [start])
    for d in Iterators.countfrom(0)
        for p in pop!(buckets, d, CartesianIndex{2}[])
            dist[p] == d || continue
            p == goal && return d
            for q in (p + δ for δ in CartesianIndex.([(1, 0), (-1, 0), (0, 1), (0, -1)]))
                checkbounds(Bool, risk, q) && d + risk[q] < dist[q] || continue
                dist[q] = d + risk[q]
                push!(get!(buckets, dist[q], CartesianIndex{2}[]), q)
            end
        end
    end
end

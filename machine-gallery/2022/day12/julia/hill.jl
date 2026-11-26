# Shared: the heightmap as a Matrix{Char}, BFS over CartesianIndex neighbours.
const STEPS = CartesianIndex.([(1, 0), (-1, 0), (0, 1), (0, -1)])

height(ch) = ch == 'S' ? 'a' : ch == 'E' ? 'z' : ch

function shortest_path(input, starts)
    grid = permutedims(reduce(hcat, collect.(split(chomp(input), '\n'))))
    dist = fill(-1, size(grid))
    queue = findall(in(starts), grid)
    dist[queue] .= 0
    while !isempty(queue)
        p = popfirst!(queue)
        grid[p] == 'E' && return dist[p]
        for q in (p + d for d in STEPS)
            checkbounds(Bool, grid, q) && dist[q] < 0 || continue
            height(grid[q]) - height(grid[p]) <= 1 || continue
            dist[q] = dist[p] + 1
            push!(queue, q)
        end
    end
    error("no path")
end

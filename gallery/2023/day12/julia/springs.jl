# Shared: bottom-up DP over a matrix: ways[i, g] = arrangements of row[i:end] using groups[g:end].
function arrangements(row::String, groups::Vector{Int})
    n, m = length(row), length(groups)
    ways = zeros(Int, n + 2, m + 1)
    ways[n+1:n+2, m+1] .= 1
    for i in n:-1:1, g in 1:m+1
        row[i] != '#' && (ways[i, g] += ways[i+1, g])
        g <= m && row[i] != '.' || continue
        size = groups[g]
        if i + size - 1 <= n && !occursin('.', row[i:i+size-1]) && get(row, i + size, '.') != '#'
            ways[i, g] += ways[min(i + size + 1, n + 2), g+1]
        end
    end
    return ways[1, 1]
end

function total_arrangements(input, copies)
    sum(split(chomp(input), '\n')) do line
        row, groups = split(line)
        arrangements(join(fill(row, copies), '?'), repeat(parse.(Int, split(groups, ',')), copies))
    end
end

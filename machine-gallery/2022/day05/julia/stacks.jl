# Shared parser: build a Char matrix from the drawing and read stacks column-wise.
function parse_stacks(input)
    drawing, procedure = split(chomp(input), "\n\n")
    rows = split(drawing, '\n')
    width = maximum(length, rows)
    grid = permutedims(reduce(hcat, [collect(rpad(r, width)) for r in rows]))   # rows × cols
    stacks = [filter(!=(' '), reverse(grid[1:end-1, c])) for c in 2:4:width]
    moves = [parse.(Int, m.captures) for m in eachmatch(r"move (\d+) from (\d+) to (\d+)", procedure)]
    return stacks, moves
end

tops(stacks) = String(last.(stacks))

# Remove and return the top n crates (bottom-to-top order).
pop_top!(stack, n) = splice!(stack, lastindex(stack)-n+1:lastindex(stack))

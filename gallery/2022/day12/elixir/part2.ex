# Backwards from E with the step rule reversed, until any square of height 'a'.
defmodule Part2 do
  import Part1

  def solve(input) do
    grid = parse(input)
    bfs(grid, find(grid, ?E), fn from, to -> from <= to + 1 end, &(height(grid[&1]) == ?a))
  end
end

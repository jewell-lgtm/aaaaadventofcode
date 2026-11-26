# Hill Climbing: level-by-level BFS. Each frontier is a MapSet built with a `for`
# comprehension whose filters express the step rule; `can_step?` and `goal?` are
# passed in so part 2 can run the search backwards from E.
defmodule Part1 do
  def parse(input) do
    for {row, r} <- input |> String.split("\n", trim: true) |> Enum.with_index(),
        {ch, c} <- row |> String.to_charlist() |> Enum.with_index(),
        into: %{},
        do: {{r, c}, ch}
  end

  def height(?S), do: ?a
  def height(?E), do: ?z
  def height(ch), do: ch

  def find(grid, ch), do: Enum.find_value(grid, fn {pos, x} -> if x == ch, do: pos end)

  def bfs(grid, start, can_step?, goal?),
    do: bfs(grid, MapSet.new([start]), MapSet.new([start]), 0, can_step?, goal?)

  defp bfs(grid, frontier, seen, steps, can_step?, goal?) do
    cond do
      Enum.empty?(frontier) ->
        nil

      Enum.any?(frontier, goal?) ->
        steps

      true ->
        next =
          for {r, c} = p <- frontier,
              q <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
              Map.has_key?(grid, q),
              q not in seen,
              can_step?.(height(grid[p]), height(grid[q])),
              into: MapSet.new(),
              do: q

        bfs(grid, next, MapSet.union(seen, next), steps + 1, can_step?, goal?)
    end
  end

  def solve(input) do
    grid = parse(input)
    goal = find(grid, ?E)
    bfs(grid, find(grid, ?S), fn from, to -> to <= from + 1 end, &(&1 == goal))
  end
end

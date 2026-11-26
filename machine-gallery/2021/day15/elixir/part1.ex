# Chiton: Dijkstra. Elixir has no heap of its own, so we borrow Erlang's :gb_sets
# (an ordered set of {distance, position}) as the priority queue. The cave is a map
# with a `risk` function, which lets part 2 tile it without building a bigger grid.
defmodule Part1 do
  def parse(input) do
    rows = String.split(input, "\n", trim: true)

    grid =
      for {row, r} <- Enum.with_index(rows),
          {ch, c} <- Enum.with_index(String.to_charlist(row)),
          into: %{} do
        {{r, c}, ch - ?0}
      end

    %{rows: length(rows), cols: String.length(hd(rows)), risk: &Map.fetch!(grid, &1)}
  end

  def lowest_risk(cave) do
    goal = {cave.rows - 1, cave.cols - 1}
    dijkstra(:gb_sets.singleton({0, {0, 0}}), %{{0, 0} => 0}, goal, cave)
  end

  defp dijkstra(queue, best, goal, cave) do
    case :gb_sets.take_smallest(queue) do
      {{dist, ^goal}, _} ->
        dist

      {{dist, pos}, queue} ->
        {queue, best} =
          pos
          |> neighbours(cave)
          |> Enum.reduce({queue, best}, fn next, {q, b} ->
            d = dist + cave.risk.(next)
            # numbers sort before atoms, so :infinity works as "no distance yet"
            if d < Map.get(b, next, :infinity),
              do: {:gb_sets.add({d, next}, q), Map.put(b, next, d)},
              else: {q, b}
          end)

        dijkstra(queue, best, goal, cave)
    end
  end

  defp neighbours({r, c}, cave) do
    for {r2, c2} <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
        r2 in 0..(cave.rows - 1)//1 and c2 in 0..(cave.cols - 1)//1,
        do: {r2, c2}
  end

  def solve(input), do: input |> parse() |> lowest_risk()
end

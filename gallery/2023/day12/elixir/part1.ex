# Hot Springs: a forward DP that reduces over the characters while carrying a map of
# {groups finished, length of current damaged run} => number of ways. Each '?' forks
# a state into its '.' and '#' successors; identical states merge, which is the memo.
defmodule Part1 do
  def arrangements(springs, groups) do
    groups = List.to_tuple(groups)

    (springs <> ".")
    |> String.graphemes()
    |> Enum.reduce(%{{0, 0} => 1}, fn ch, states ->
      for {state, ways} <- states, next <- successors(ch, state, groups), reduce: %{} do
        acc -> Map.update(acc, next, ways, &(&1 + ways))
      end
    end)
    |> Map.get({tuple_size(groups), 0}, 0)
  end

  defp successors("?", state, groups),
    do: successors(".", state, groups) ++ successors("#", state, groups)

  defp successors(".", {done, 0}, _groups), do: [{done, 0}]
  defp successors(".", {done, run}, groups) when run == elem(groups, done), do: [{done + 1, 0}]
  defp successors(".", _state, _groups), do: []

  defp successors("#", {done, run}, groups)
       when done < tuple_size(groups) and run < elem(groups, done),
       do: [{done, run + 1}]

  defp successors("#", _state, _groups), do: []

  def parse_line(line) do
    [springs, groups] = String.split(line)
    {springs, groups |> String.split(",") |> Enum.map(&String.to_integer/1)}
  end

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {springs, groups} -> arrangements(springs, groups) end)
    |> Enum.sum()
  end
end

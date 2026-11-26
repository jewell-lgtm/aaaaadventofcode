# Unfold each row five times (springs joined by "?"), then the same DP.
defmodule Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Part1.parse_line/1)
    |> Enum.map(fn {springs, groups} ->
      Part1.arrangements(
        List.duplicate(springs, 5) |> Enum.join("?"),
        List.duplicate(groups, 5) |> List.flatten()
      )
    end)
    |> Enum.sum()
  end
end

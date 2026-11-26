# Report Repair: recurse down the list with function-clause pattern matching; for each
# head, check whether its complement appears later. O(n^2) is plenty for 200 entries
# and reads like the puzzle statement.
defmodule Part1 do
  def parse(input), do: input |> String.split() |> Enum.map(&String.to_integer/1)

  def pair_product([], _target), do: nil

  def pair_product([x | rest], target) do
    if (target - x) in rest, do: x * (target - x), else: pair_product(rest, target)
  end

  def solve(input), do: input |> parse() |> pair_product(2020)
end

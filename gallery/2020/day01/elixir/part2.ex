# Fix the head x, reuse part 1's pair search on the tail for 2020 - x.
defmodule Part2 do
  def triple_product([], _target), do: nil

  def triple_product([x | rest], target) do
    case Part1.pair_product(rest, target - x) do
      nil -> triple_product(rest, target)
      product -> x * product
    end
  end

  def solve(input), do: input |> Part1.parse() |> triple_product(2020)
end

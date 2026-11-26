# Mull It Over: Regex.scan returns the capture groups of every match;
# multiply and sum them in one pipeline.
defmodule Part1 do
  def solve(input) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(fn [a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end
end

# One regex for all three instructions; the reducer pattern-matches on the shape
# of each match (["do()"], ["don't()"], [_, a, b]) and on the enabled flag.
defmodule Part2 do
  def solve(input) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/
    |> Regex.scan(input)
    |> Enum.reduce({true, 0}, fn
      ["do()"], {_, sum} -> {true, sum}
      ["don't()"], {_, sum} -> {false, sum}
      [_, a, b], {true, sum} -> {true, sum + String.to_integer(a) * String.to_integer(b)}
      _, acc -> acc
    end)
    |> elem(1)
  end
end

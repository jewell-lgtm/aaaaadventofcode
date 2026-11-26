# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
defmodule Main do
  def main do
    input = IO.read(:stdio, :eof)
    solver = if System.get_env("AOC_PART") == "2", do: Part2, else: Part1
    input |> solver.solve() |> to_string() |> IO.puts()
  end
end

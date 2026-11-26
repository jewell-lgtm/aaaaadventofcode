# Harness helpers.
#   Aoc.example?(): true when running an example (aoc test).
#   Aoc.arg("size", 71): example-specific constant from examples.toml `args`, else the default.
defmodule Aoc do
  def example?, do: System.get_env("AOC_EXAMPLE") == "1"

  def arg(name, default) do
    System.get_env("AOC_ARGS", "{}") |> JSON.decode!() |> Map.get(name, default)
  end
end

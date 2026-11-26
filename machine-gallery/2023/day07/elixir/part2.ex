# Jokers: weakest for tie-breaks, wildcard for the hand type.
defmodule Part2 do
  def solve(input), do: Part1.winnings(input, true)
end

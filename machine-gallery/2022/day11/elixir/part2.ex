# No more relief: reduce worry modulo the product of all (prime) divisors, which keeps
# every divisibility test intact. Elixir integers are bignums, but this keeps them small.
defmodule Part2 do
  def solve(input) do
    Part1.monkey_business(input, 10_000, fn monkeys ->
      modulus = monkeys |> Enum.map(& &1.divisor) |> Enum.product()
      &rem(&1, modulus)
    end)
  end
end

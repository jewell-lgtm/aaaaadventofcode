# Monkey in the Middle: each block is destructured with binary prefix patterns
# ("  Test: divisible by " <> n), the operation becomes a closure, and rounds are
# reduced over a map of held items. `relief` is div 3 now, mod lcm in part 2.
defmodule Part1 do
  def parse_monkey(block) do
    [
      _header,
      "  Starting items: " <> items,
      "  Operation: new = " <> expr,
      "  Test: divisible by " <> divisor,
      "    If true: throw to monkey " <> on_true,
      "    If false: throw to monkey " <> on_false
    ] = String.split(block, "\n", trim: true)

    %{
      items: items |> String.split(", ") |> Enum.map(&String.to_integer/1),
      op: parse_op(String.split(expr)),
      divisor: String.to_integer(divisor),
      on_true: String.to_integer(on_true),
      on_false: String.to_integer(on_false)
    }
  end

  defp parse_op(["old", "*", "old"]), do: &(&1 * &1)
  defp parse_op(["old", "*", n]), do: &(&1 * String.to_integer(n))
  defp parse_op(["old", "+", n]), do: &(&1 + String.to_integer(n))

  def parse(input), do: input |> String.split("\n\n", trim: true) |> Enum.map(&parse_monkey/1)

  def monkey_business(input, rounds, relief) do
    monkeys = parse(input) |> Enum.with_index() |> Map.new(fn {m, i} -> {i, m} end)
    held = Map.new(monkeys, fn {i, m} -> {i, m.items} end)
    relieve = relief.(Map.values(monkeys))
    ids = 0..(map_size(monkeys) - 1)

    {_held, inspected} =
      Enum.reduce(1..rounds, {held, %{}}, fn _round, state ->
        Enum.reduce(ids, state, fn i, state -> turn(monkeys[i], i, state, relieve) end)
      end)

    inspected |> Map.values() |> Enum.sort(:desc) |> Enum.take(2) |> Enum.product()
  end

  defp turn(monkey, i, {held, inspected}, relieve) do
    items = held[i]

    held =
      Enum.reduce(items, Map.put(held, i, []), fn worry, held ->
        worry = relieve.(monkey.op.(worry))
        target = if rem(worry, monkey.divisor) == 0, do: monkey.on_true, else: monkey.on_false
        Map.update!(held, target, &(&1 ++ [worry]))
      end)

    {held, Map.update(inspected, i, length(items), &(&1 + length(items)))}
  end

  def solve(input), do: monkey_business(input, 20, fn _monkeys -> &div(&1, 3) end)
end

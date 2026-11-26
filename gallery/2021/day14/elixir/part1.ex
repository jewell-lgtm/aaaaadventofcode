# Extended Polymerization: never build the polymer. Count adjacent pairs with
# Enum.frequencies, and each step turn pair AB (rule C) into AC and CB.
# Element counts = first letter of every pair, plus the template's last letter.
defmodule Part1 do
  def spread(input, steps) do
    [template | rules] = String.split(input, "\n", trim: true)

    rules =
      Map.new(rules, fn rule ->
        [pair, insert] = String.split(rule, " -> ")
        {String.graphemes(pair), insert}
      end)

    letters = String.graphemes(template)

    pairs =
      Enum.reduce(1..steps, Enum.frequencies(Enum.chunk_every(letters, 2, 1, :discard)), fn _,
                                                                                            pairs ->
        Enum.reduce(pairs, %{}, fn {[a, b] = pair, n}, acc ->
          case rules do
            %{^pair => c} -> acc |> add([a, c], n) |> add([c, b], n)
            _ -> add(acc, pair, n)
          end
        end)
      end)

    {min, max} =
      pairs
      |> Enum.reduce(%{List.last(letters) => 1}, fn {[a, _], n}, acc -> add(acc, a, n) end)
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  defp add(map, key, n), do: Map.update(map, key, n, &(&1 + n))

  def solve(input), do: spread(input, 10)
end

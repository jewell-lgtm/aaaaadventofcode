# Camel Cards: Enum.sort_by a key of {hand type, card strengths}; Erlang term order
# compares tuples and lists element-wise, so no custom comparator is needed.
# The hand type is a `case` on the sorted group sizes.
defmodule Part1 do
  def hand_type(cards, jokers? \\ false) do
    {jokers, rest} =
      if jokers?,
        do: {Enum.count(cards, &(&1 == ?J)), Enum.reject(cards, &(&1 == ?J))},
        else: {0, cards}

    groups =
      case rest |> Enum.frequencies() |> Map.values() |> Enum.sort(:desc) do
        [] -> [jokers]
        [biggest | others] -> [biggest + jokers | others]
      end

    case groups do
      [5] -> 6
      [4, 1] -> 5
      [3, 2] -> 4
      [3, 1, 1] -> 3
      [2, 2, 1] -> 2
      [2, 1, 1, 1] -> 1
      _ -> 0
    end
  end

  def winnings(input, jokers?) do
    order = if jokers?, do: ~c"J23456789TQKA", else: ~c"23456789TJQKA"
    strength = fn card -> Enum.find_index(order, &(&1 == card)) end

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)
      cards = String.to_charlist(hand)
      {{hand_type(cards, jokers?), Enum.map(cards, strength)}, String.to_integer(bid)}
    end)
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_key, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def solve(input), do: winnings(input, false)
end

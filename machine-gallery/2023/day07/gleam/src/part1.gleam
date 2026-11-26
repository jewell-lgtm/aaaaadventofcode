//// Camel Cards: `list.sort` with an explicit comparator built from `order.break_tie`:
//// hand type first, then card strengths left to right. The hand type is a case on the
//// group sizes; with jokers, J is the weakest card and joins the biggest group.

import aoc
import gleam/dict
import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/string

type Hand {
  Hand(kind: Int, strengths: List(Int), bid: Int)
}

fn kind(cards: List(String), jokers: Bool) -> Int {
  let #(wild, rest) = list.partition(cards, fn(c) { jokers && c == "J" })
  let groups =
    list.group(rest, fn(c) { c })
    |> dict.values
    |> list.map(list.length)
    |> list.sort(order.reverse(int.compare))
  let groups = case groups {
    [] -> [list.length(wild)]
    [biggest, ..others] -> [biggest + list.length(wild), ..others]
  }
  case groups {
    [5] -> 6
    [4, 1] -> 5
    [3, 2] -> 4
    [3, 1, 1] -> 3
    [2, 2, 1] -> 2
    [2, 1, 1, 1] -> 1
    _ -> 0
  }
}

fn parse_hand(line: String, jokers: Bool) -> Hand {
  let assert [cards, bid] = string.split(line, " ")
  let assert Ok(bid) = int.parse(bid)
  let order = case jokers {
    True -> "J23456789TQKA"
    False -> "23456789TJQKA"
  }
  let strength =
    string.to_graphemes(order)
    |> list.index_map(fn(c, i) { #(c, i) })
    |> dict.from_list
  let cards = string.to_graphemes(cards)
  let strengths = list.filter_map(cards, dict.get(strength, _))
  Hand(kind: kind(cards, jokers), strengths:, bid:)
}

fn compare_cards(a: List(Int), b: List(Int)) -> Order {
  case a, b {
    [x, ..xs], [y, ..ys] ->
      int.compare(x, y) |> order.lazy_break_tie(fn() { compare_cards(xs, ys) })
    _, _ -> order.Eq
  }
}

fn compare(a: Hand, b: Hand) -> Order {
  int.compare(a.kind, b.kind)
  |> order.lazy_break_tie(fn() { compare_cards(a.strengths, b.strengths) })
}

pub fn winnings(input: String, jokers: Bool) -> String {
  aoc.lines(input)
  |> list.map(parse_hand(_, jokers))
  |> list.sort(compare)
  |> list.index_map(fn(hand, i) { hand.bid * { i + 1 } })
  |> int.sum
  |> int.to_string
}

pub fn solve(input: String) -> String {
  winnings(input, False)
}

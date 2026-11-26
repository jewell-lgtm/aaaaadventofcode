//// Extended Polymerization: never build the polymer. Count adjacent pairs
//// (`list.window_by_2`) in a Dict; each step, pair (a, b) with rule c becomes (a, c)
//// and (c, b). Element counts = first letter of each pair, plus the last letter.

import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/string

type Pair =
  #(String, String)

fn add(counts: Dict(k, Int), key: k, n: Int) -> Dict(k, Int) {
  dict.upsert(counts, key, fn(old) { option.unwrap(old, 0) + n })
}

fn step(pairs: Dict(Pair, Int), rules: Dict(Pair, String)) -> Dict(Pair, Int) {
  use acc, pair, n <- dict.fold(pairs, dict.new())
  case dict.get(rules, pair) {
    Ok(c) -> acc |> add(#(pair.0, c), n) |> add(#(c, pair.1), n)
    Error(Nil) -> add(acc, pair, n)
  }
}

pub fn spread(input: String, steps: Int) -> Int {
  let assert [template, ..rule_lines] = aoc.lines(input)
  let rules =
    rule_lines
    |> list.map(fn(line) {
      let assert [a, b, " ", "-", ">", " ", c] = string.to_graphemes(line)
      #(#(a, b), c)
    })
    |> dict.from_list
  let letters = string.to_graphemes(template)
  let start =
    list.window_by_2(letters)
    |> list.fold(dict.new(), fn(acc, p) { add(acc, p, 1) })
  let final = int.range(0, steps, start, fn(pairs, _) { step(pairs, rules) })
  let assert Ok(last) = list.last(letters)
  let counts =
    dict.fold(final, dict.from_list([#(last, 1)]), fn(acc, pair, n) {
      add(acc, pair.0, n)
    })
    |> dict.values
  let assert Ok(most) = list.max(counts, int.compare)
  let assert Ok(least) = list.max(counts, fn(a, b) { int.compare(b, a) })
  most - least
}

pub fn solve(input: String) -> String {
  spread(input, 10) |> int.to_string
}

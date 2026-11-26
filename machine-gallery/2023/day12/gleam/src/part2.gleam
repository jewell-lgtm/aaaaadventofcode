//// Unfold each row five times (springs joined by "?"), then the same DP.

import aoc
import gleam/int
import gleam/list
import gleam/string
import part1

pub fn solve(input: String) -> String {
  aoc.lines(input)
  |> list.map(part1.parse_line)
  |> list.map(fn(row) {
    let #(springs, groups) = row
    part1.arrangements(
      list.repeat(springs, 5) |> string.join("?"),
      list.repeat(groups, 5) |> list.flatten,
    )
  })
  |> int.sum
  |> int.to_string
}

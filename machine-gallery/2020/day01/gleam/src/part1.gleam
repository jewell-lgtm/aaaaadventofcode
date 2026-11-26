//// Report Repair: recurse over the list with pattern matching; for each head,
//// look for its complement in the tail. O(n^2) is plenty for 200 entries.

import aoc
import gleam/int
import gleam/list
import gleam/result

pub fn parse(input: String) -> List(Int) {
  input |> aoc.lines |> list.filter_map(int.parse)
}

pub fn pair_product(nums: List(Int), target: Int) -> Result(Int, Nil) {
  case nums {
    [] -> Error(Nil)
    [x, ..rest] ->
      case list.contains(rest, target - x) {
        True -> Ok(x * { target - x })
        False -> pair_product(rest, target)
      }
  }
}

pub fn solve(input: String) -> String {
  parse(input) |> pair_product(2020) |> result.unwrap(0) |> int.to_string
}

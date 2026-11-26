//// Fix the head x and reuse part 1's pair search on the tail for 2020 - x;
//// `result.lazy_or` falls through to the next head when that fails.

import gleam/int
import gleam/result
import part1

fn triple_product(nums: List(Int), target: Int) -> Result(Int, Nil) {
  case nums {
    [] -> Error(Nil)
    [x, ..rest] ->
      part1.pair_product(rest, target - x)
      |> result.map(fn(p) { x * p })
      |> result.lazy_or(fn() { triple_product(rest, target) })
  }
}

pub fn solve(input: String) -> String {
  part1.parse(input)
  |> triple_product(2020)
  |> result.unwrap(0)
  |> int.to_string
}

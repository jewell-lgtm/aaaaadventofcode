//// 40 steps: the pair Dict stays tiny, so this is as fast as part 1.

import gleam/int
import part1

pub fn solve(input: String) -> String {
  part1.spread(input, 40) |> int.to_string
}

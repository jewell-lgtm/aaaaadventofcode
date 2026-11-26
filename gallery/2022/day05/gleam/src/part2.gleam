//// The CrateMover 9001 moves crates as a block, keeping their order.

import gleam/function
import part1

pub fn solve(input: String) -> String {
  part1.run(input, function.identity)
}

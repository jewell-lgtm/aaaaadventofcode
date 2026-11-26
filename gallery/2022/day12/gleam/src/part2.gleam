//// Backwards from E with the step rule reversed, until any square of height 'a'.

import gleam/dict
import part1

pub fn solve(input: String) -> String {
  let hill = part1.parse(input)
  let lowest = 97
  part1.bfs(
    hill,
    from: hill.end,
    can_step: fn(a, b) { a <= b + 1 },
    until: fn(p) { dict.get(hill.heights, p) == Ok(lowest) },
  )
  |> part1.result_to_string
}

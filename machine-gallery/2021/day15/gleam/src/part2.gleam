//// Tile the cave 5x5: every tile step adds 1 to the risk, wrapping 9 back to 1.

import gleam/int
import part1.{type Cave, Cave}

fn tile(cave: Cave) -> Cave {
  let Cave(rows: h, cols: w, risk:) = cave
  Cave(rows: 5 * h, cols: 5 * w, risk: fn(pos) {
    let #(r, c) = pos
    { risk(#(r % h, c % w)) + r / h + c / w - 1 } % 9 + 1
  })
}

pub fn solve(input: String) -> String {
  input |> part1.parse |> tile |> part1.lowest_risk |> int.to_string
}

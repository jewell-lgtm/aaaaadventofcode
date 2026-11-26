// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
import aoc
import gleam/io
import part1
import part2

pub fn main() -> Nil {
  let input = aoc.read_stdin()
  let solve = case aoc.env("AOC_PART") {
    Ok("2") -> part2.solve
    _ -> part1.solve
  }
  io.println(solve(input))
}

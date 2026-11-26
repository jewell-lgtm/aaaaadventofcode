//// Hill Climbing: level-by-level BFS over immutable Sets. Parsing produces a Hill
//// record (heights plus the S and E positions); `bfs` takes the step rule and goal
//// as functions, so part 2 can run the same search backwards from E.

import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string

pub type Pos =
  #(Int, Int)

pub type Hill {
  Hill(heights: Dict(Pos, Int), start: Pos, end: Pos)
}

fn elevation(ch: String) -> Int {
  let ch = case ch {
    "S" -> "a"
    "E" -> "z"
    _ -> ch
  }
  let assert [cp] = string.to_utf_codepoints(ch)
  string.utf_codepoint_to_int(cp)
}

pub fn parse(input: String) -> Hill {
  let cells =
    aoc.lines(input)
    |> list.index_map(fn(line, r) {
      string.to_graphemes(line) |> list.index_map(fn(ch, c) { #(#(r, c), ch) })
    })
    |> list.flatten
  let assert Ok(#(start, _)) = list.find(cells, fn(cell) { cell.1 == "S" })
  let assert Ok(#(end, _)) = list.find(cells, fn(cell) { cell.1 == "E" })
  let heights =
    cells
    |> list.map(fn(cell) { #(cell.0, elevation(cell.1)) })
    |> dict.from_list
  Hill(heights:, start:, end:)
}

pub fn bfs(
  hill: Hill,
  from start: Pos,
  can_step can_step: fn(Int, Int) -> Bool,
  until goal: fn(Pos) -> Bool,
) -> Result(Int, Nil) {
  let first = set.from_list([start])
  search(hill.heights, first, first, 0, can_step, goal)
}

fn search(
  heights: Dict(Pos, Int),
  frontier: Set(Pos),
  seen: Set(Pos),
  steps: Int,
  can_step: fn(Int, Int) -> Bool,
  goal: fn(Pos) -> Bool,
) -> Result(Int, Nil) {
  let current = set.to_list(frontier)
  case current, list.any(current, goal) {
    [], _ -> Error(Nil)
    _, True -> Ok(steps)
    _, False -> {
      let next =
        current
        |> list.flat_map(fn(p) { moves(heights, p, can_step) })
        |> set.from_list
        |> set.difference(seen)
      search(heights, next, set.union(seen, next), steps + 1, can_step, goal)
    }
  }
}

fn moves(
  heights: Dict(Pos, Int),
  p: Pos,
  can_step: fn(Int, Int) -> Bool,
) -> List(Pos) {
  let #(r, c) = p
  let assert Ok(here) = dict.get(heights, p)
  [#(r - 1, c), #(r + 1, c), #(r, c - 1), #(r, c + 1)]
  |> list.filter(fn(q) {
    case dict.get(heights, q) {
      Ok(there) -> can_step(here, there)
      Error(Nil) -> False
    }
  })
}

pub fn solve(input: String) -> String {
  let hill = parse(input)
  bfs(hill, from: hill.start, can_step: fn(a, b) { b <= a + 1 }, until: fn(p) {
    p == hill.end
  })
  |> result_to_string
}

pub fn result_to_string(r: Result(Int, Nil)) -> String {
  case r {
    Ok(n) -> int.to_string(n)
    Error(Nil) -> "unreachable"
  }
}

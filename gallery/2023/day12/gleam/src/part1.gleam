//// Hot Springs: recursive count over the remaining (springs, groups), pattern matching
//// on the head spring. Gleam has no mutation, so the memo is a Dict threaded through
//// every call and returned alongside each result.

import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

type Memo =
  Dict(#(Int, Int), Int)

pub fn arrangements(springs: String, groups: List(Int)) -> Int {
  let #(n, _memo) = count(string.to_graphemes(springs), groups, dict.new())
  n
}

/// Both lists are suffixes of the originals, so their lengths identify the subproblem.
fn count(springs: List(String), groups: List(Int), memo: Memo) -> #(Int, Memo) {
  let key = #(list.length(springs), list.length(groups))
  case dict.get(memo, key) {
    Ok(n) -> #(n, memo)
    Error(Nil) -> {
      let #(n, memo) = step(springs, groups, memo)
      #(n, dict.insert(memo, key, n))
    }
  }
}

fn step(springs: List(String), groups: List(Int), memo: Memo) -> #(Int, Memo) {
  case springs, groups {
    [], [] -> #(1, memo)
    [], _ -> #(0, memo)
    [".", ..rest], _ -> count(rest, groups, memo)
    ["#", ..], _ -> damaged(springs, groups, memo)
    [_, ..rest], _ -> {
      let #(a, memo) = count(rest, groups, memo)
      let #(b, memo) = damaged(springs, groups, memo)
      #(a + b, memo)
    }
  }
}

/// Place the next group at the front: g springs with no '.', then the end or a non-'#'.
fn damaged(
  springs: List(String),
  groups: List(Int),
  memo: Memo,
) -> #(Int, Memo) {
  case groups {
    [] -> #(0, memo)
    [g, ..rest_groups] -> {
      let #(run, after) = list.split(springs, g)
      let fits = list.length(run) == g && !list.contains(run, ".")
      case fits, after {
        True, [] -> count([], rest_groups, memo)
        True, [separator, ..rest] if separator != "#" ->
          count(rest, rest_groups, memo)
        _, _ -> #(0, memo)
      }
    }
  }
}

pub fn parse_line(line: String) -> #(String, List(Int)) {
  let assert [springs, groups] = string.split(line, " ")
  #(springs, string.split(groups, ",") |> list.filter_map(int.parse))
}

pub fn solve(input: String) -> String {
  aoc.lines(input)
  |> list.map(parse_line)
  |> list.map(fn(row) { arrangements(row.0, row.1) })
  |> int.sum
  |> int.to_string
}

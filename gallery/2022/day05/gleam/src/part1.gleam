//// Supply Stacks: `list.transpose` the drawing so each stack becomes a column (top
//// crate first), keyed by its label digit. Moves fold over a Dict of stacks; `crane`
//// decides whether lifted crates flip (CrateMover 9000) or keep order (9001).

import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/string

type Stacks =
  Dict(Int, List(String))

fn parse_stacks(drawing: String) -> Stacks {
  drawing
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.filter_map(fn(column) {
    let #(crates, label) = list.split(column, list.length(column) - 1)
    case label {
      [digit] ->
        case int.parse(digit) {
          Ok(n) -> Ok(#(n, list.filter(crates, fn(c) { c != " " })))
          Error(Nil) -> Error(Nil)
        }
      _ -> Error(Nil)
    }
  })
  |> dict.from_list
}

fn parse_move(line: String) -> #(Int, Int, Int) {
  let assert ["move", n, "from", from, "to", to] = string.split(line, " ")
  let assert [Ok(n), Ok(from), Ok(to)] = list.map([n, from, to], int.parse)
  #(n, from, to)
}

fn apply_move(stacks: Stacks, move: #(Int, Int, Int), crane) -> Stacks {
  let #(n, from, to) = move
  let assert Ok(source) = dict.get(stacks, from)
  let #(lifted, rest) = list.split(source, n)
  stacks
  |> dict.insert(from, rest)
  |> dict.upsert(to, fn(stack) {
    list.append(crane(lifted), option.unwrap(stack, []))
  })
}

pub fn run(input: String, crane: fn(List(String)) -> List(String)) -> String {
  let assert Ok(#(drawing, moves)) = string.split_once(input, "\n\n")
  moves
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.map(parse_move)
  |> list.fold(parse_stacks(drawing), fn(stacks, move) {
    apply_move(stacks, move, crane)
  })
  |> dict.to_list
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.filter_map(fn(entry) { list.first(entry.1) })
  |> string.concat
}

pub fn solve(input: String) -> String {
  run(input, list.reverse)
}

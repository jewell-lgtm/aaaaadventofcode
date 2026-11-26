//// Chiton: Dijkstra. The stdlib has no priority queue, so we define a pairing heap
//// as a custom type in a dozen lines. The cave is a record with a `risk` function,
//// which lets part 2 tile it without building a bigger grid.

import aoc
import gleam/dict
import gleam/int
import gleam/list
import gleam/string

pub type Cave {
  Cave(rows: Int, cols: Int, risk: fn(#(Int, Int)) -> Int)
}

pub fn parse(input: String) -> Cave {
  let lines = aoc.lines(input)
  let grid =
    lines
    |> list.index_map(fn(line, r) {
      string.to_graphemes(line)
      |> list.index_map(fn(ch, c) {
        let assert Ok(n) = int.parse(ch)
        #(#(r, c), n)
      })
    })
    |> list.flatten
    |> dict.from_list
  let assert [first, ..] = lines
  Cave(rows: list.length(lines), cols: string.length(first), risk: fn(pos) {
    let assert Ok(n) = dict.get(grid, pos)
    n
  })
}

// --- pairing heap keyed by Int ------------------------------------------------

type Heap(a) {
  Empty
  Node(key: Int, value: a, children: List(Heap(a)))
}

fn merge(a: Heap(v), b: Heap(v)) -> Heap(v) {
  case a, b {
    Empty, h | h, Empty -> h
    Node(ka, va, ca), Node(kb, vb, cb) ->
      case ka <= kb {
        True -> Node(ka, va, [b, ..ca])
        False -> Node(kb, vb, [a, ..cb])
      }
  }
}

fn push(heap: Heap(v), key: Int, value: v) -> Heap(v) {
  merge(heap, Node(key, value, []))
}

fn pop(heap: Heap(v)) -> Result(#(Int, v, Heap(v)), Nil) {
  case heap {
    Empty -> Error(Nil)
    Node(key, value, children) -> Ok(#(key, value, merge_pairs(children)))
  }
}

fn merge_pairs(heaps: List(Heap(v))) -> Heap(v) {
  case heaps {
    [] -> Empty
    [h] -> h
    [a, b, ..rest] -> merge(merge(a, b), merge_pairs(rest))
  }
}

// --- Dijkstra -----------------------------------------------------------------

pub fn lowest_risk(cave: Cave) -> Int {
  let goal = #(cave.rows - 1, cave.cols - 1)
  dijkstra(cave, goal, push(Empty, 0, #(0, 0)), dict.from_list([#(#(0, 0), 0)]))
}

fn dijkstra(cave: Cave, goal, queue, best) -> Int {
  let assert Ok(#(dist, pos, queue)) = pop(queue)
  case pos == goal {
    True -> dist
    False -> {
      let #(queue, best) =
        neighbours(cave, pos)
        |> list.fold(#(queue, best), fn(acc, next) {
          let d = dist + cave.risk(next)
          case dict.get(acc.1, next) {
            Ok(known) if known <= d -> acc
            _ -> #(push(acc.0, d, next), dict.insert(acc.1, next, d))
          }
        })
      dijkstra(cave, goal, queue, best)
    }
  }
}

fn neighbours(cave: Cave, pos: #(Int, Int)) -> List(#(Int, Int)) {
  let #(r, c) = pos
  [#(r - 1, c), #(r + 1, c), #(r, c - 1), #(r, c + 1)]
  |> list.filter(fn(p) {
    p.0 >= 0 && p.1 >= 0 && p.0 < cave.rows && p.1 < cave.cols
  })
}

pub fn solve(input: String) -> String {
  input |> parse |> lowest_risk |> int.to_string
}

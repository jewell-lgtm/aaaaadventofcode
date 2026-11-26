//// Monkey in the Middle: `let assert` with string prefix patterns pulls each block
//// apart into a Monkey record whose op is a closure; rounds fold over a Dict of held
//// items. `relief` is division by 3 here, modulo the product of divisors in part 2.

import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string

pub type Monkey {
  Monkey(op: fn(Int) -> Int, divisor: Int, on_true: Int, on_false: Int)
}

fn to_int(s: String) -> Int {
  let assert Ok(n) = int.parse(s)
  n
}

fn parse_op(op: String) -> fn(Int) -> Int {
  case string.split(op, " ") {
    ["*", "old"] -> fn(x) { x * x }
    ["*", n] -> {
      let n = to_int(n)
      fn(x) { x * n }
    }
    ["+", n] -> {
      let n = to_int(n)
      fn(x) { x + n }
    }
    _ -> panic as { "unknown operation: " <> op }
  }
}

fn parse_monkey(block: String) -> #(List(Int), Monkey) {
  let assert [
    _,
    "  Starting items: " <> items,
    "  Operation: new = old " <> op,
    "  Test: divisible by " <> divisor,
    "    If true: throw to monkey " <> on_true,
    "    If false: throw to monkey " <> on_false,
  ] = aoc.lines(block)
  #(
    string.split(items, ", ") |> list.map(to_int),
    Monkey(
      op: parse_op(op),
      divisor: to_int(divisor),
      on_true: to_int(on_true),
      on_false: to_int(on_false),
    ),
  )
}

type State {
  State(held: Dict(Int, List(Int)), inspected: Dict(Int, Int))
}

pub fn monkey_business(
  input: String,
  rounds: Int,
  relief: fn(List(Monkey)) -> fn(Int) -> Int,
) -> Int {
  let #(items, monkeys) =
    string.split(string.trim(input), "\n\n")
    |> list.map(parse_monkey)
    |> list.unzip
  let relieve = relief(monkeys)
  let numbered = list.index_map(monkeys, fn(m, i) { #(i, m) })
  let start =
    State(
      held: list.index_map(items, fn(xs, i) { #(i, xs) }) |> dict.from_list,
      inspected: dict.new(),
    )
  let final =
    int.range(0, rounds, start, fn(state, _round) {
      list.fold(numbered, state, fn(state, monkey) {
        turn(state, monkey, relieve)
      })
    })
  case dict.values(final.inspected) |> list.sort(order.reverse(int.compare)) {
    [a, b, ..] -> a * b
    _ -> 0
  }
}

fn turn(
  state: State,
  numbered: #(Int, Monkey),
  relieve: fn(Int) -> Int,
) -> State {
  let #(i, monkey) = numbered
  let assert Ok(items) = dict.get(state.held, i)
  let held =
    list.fold(items, dict.insert(state.held, i, []), fn(held, worry) {
      let worry = relieve(monkey.op(worry))
      let target = case worry % monkey.divisor == 0 {
        True -> monkey.on_true
        False -> monkey.on_false
      }
      dict.upsert(held, target, fn(xs) {
        list.append(option.unwrap(xs, []), [worry])
      })
    })
  let inspected =
    dict.upsert(state.inspected, i, fn(n) {
      option.unwrap(n, 0) + list.length(items)
    })
  State(held:, inspected:)
}

pub fn solve(input: String) -> String {
  monkey_business(input, 20, fn(_) { fn(w) { w / 3 } }) |> int.to_string
}

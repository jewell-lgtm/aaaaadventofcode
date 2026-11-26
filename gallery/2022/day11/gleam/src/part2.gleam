//// No more relief: reduce worry modulo the product of all (prime) divisors, which
//// keeps every divisibility test intact.

import gleam/int
import gleam/list
import part1

pub fn solve(input: String) -> String {
  part1.monkey_business(input, 10_000, fn(monkeys) {
    let modulus = monkeys |> list.map(fn(m) { m.divisor }) |> int.product
    fn(w) { w % modulus }
  })
  |> int.to_string
}

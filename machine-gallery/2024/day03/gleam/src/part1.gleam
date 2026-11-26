//// Mull It Over: the stdlib has no regex, and Gleam doesn't need one here. String
//// prefix patterns ("mul(" <> rest) drive a small scanner, `use` chains the argument
//// parsing, and the result is a list of instruction variants to fold over.

import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Instr {
  Do
  Dont
  Mul(Int, Int)
}

pub fn instructions(input: String) -> List(Instr) {
  scan(input, [])
}

fn scan(s: String, acc: List(Instr)) -> List(Instr) {
  case s {
    "do()" <> rest -> scan(rest, [Do, ..acc])
    "don't()" <> rest -> scan(rest, [Dont, ..acc])
    "mul(" <> rest ->
      case mul_args(rest) {
        Ok(#(instr, rest)) -> scan(rest, [instr, ..acc])
        Error(Nil) -> scan(rest, acc)
      }
    _ ->
      case string.pop_grapheme(s) {
        Ok(#(_, rest)) -> scan(rest, acc)
        Error(Nil) -> list.reverse(acc)
      }
  }
}

fn mul_args(s: String) -> Result(#(Instr, String), Nil) {
  use #(a, s) <- result.try(number(s))
  use s <- result.try(expect(s, ","))
  use #(b, s) <- result.try(number(s))
  use s <- result.try(expect(s, ")"))
  Ok(#(Mul(a, b), s))
}

/// One to three digits.
fn number(s: String) -> Result(#(Int, String), Nil) {
  let digits =
    string.slice(s, 0, 3)
    |> string.to_graphemes
    |> list.take_while(fn(c) { string.contains("0123456789", c) })
  use n <- result.try(int.parse(string.concat(digits)))
  Ok(#(n, string.drop_start(s, list.length(digits))))
}

fn expect(s: String, prefix: String) -> Result(String, Nil) {
  case string.starts_with(s, prefix) {
    True -> Ok(string.drop_start(s, string.length(prefix)))
    False -> Error(Nil)
  }
}

pub fn solve(input: String) -> String {
  instructions(input)
  |> list.fold(0, fn(sum, instr) {
    case instr {
      Mul(a, b) -> sum + a * b
      Do | Dont -> sum
    }
  })
  |> int.to_string
}

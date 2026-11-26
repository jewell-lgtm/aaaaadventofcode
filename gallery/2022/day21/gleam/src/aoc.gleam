//// Harness helpers.
////   aoc.example(): True when running an example (aoc test).
////   aoc.arg_int("size", 71): example-specific constant from examples.toml `args`, else the default.
////   aoc.lines(input): non-empty lines.

import gleam/int
import gleam/list
import gleam/result
import gleam/string

@external(erlang, "aoc_ffi", "read_stdin")
pub fn read_stdin() -> String

@external(erlang, "aoc_ffi", "getenv")
pub fn env(name: String) -> Result(String, Nil)

@external(erlang, "aoc_ffi", "arg")
fn raw_arg(name: String) -> Result(String, Nil)

pub fn example() -> Bool {
  env("AOC_EXAMPLE") == Ok("1")
}

pub fn arg_string(name: String, default: String) -> String {
  raw_arg(name) |> result.unwrap(default)
}

pub fn arg_int(name: String, default: Int) -> Int {
  raw_arg(name) |> result.try(int.parse) |> result.unwrap(default)
}

pub fn lines(input: String) -> List(String) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
}

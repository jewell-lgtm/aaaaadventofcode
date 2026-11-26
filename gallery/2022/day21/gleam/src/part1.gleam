//// Monkey Math: each monkey's job is a custom type (a number or an operation on two
//// other monkeys) stored in a Dict; `eval` recurses with a case per variant.

import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

pub type Job {
  Num(Int)
  Op(op: String, left: String, right: String)
}

pub fn parse(input: String) -> Dict(String, Job) {
  aoc.lines(input)
  |> list.map(fn(line) {
    let assert Ok(#(name, job)) = string.split_once(line, ": ")
    case string.split(job, " ") {
      [left, op, right] -> #(name, Op(op, left, right))
      _ -> {
        let assert Ok(n) = int.parse(job)
        #(name, Num(n))
      }
    }
  })
  |> dict.from_list
}

pub fn job(jobs: Dict(String, Job), name: String) -> Job {
  let assert Ok(job) = dict.get(jobs, name)
  job
}

pub fn eval(jobs: Dict(String, Job), name: String) -> Int {
  case job(jobs, name) {
    Num(n) -> n
    Op(op, left, right) -> {
      let a = eval(jobs, left)
      let b = eval(jobs, right)
      case op {
        "+" -> a + b
        "-" -> a - b
        "*" -> a * b
        _ -> a / b
      }
    }
  }
}

pub fn solve(input: String) -> String {
  parse(input) |> eval("root") |> int.to_string
}

//// "humn" is the unknown. Walk down from root along the side that depends on humn,
//// inverting each operation against the other side's constant value.

import gleam/dict.{type Dict}
import gleam/int
import part1.{type Job, Num, Op}

fn depends_on_humn(jobs: Dict(String, Job), name: String) -> Bool {
  case name, part1.job(jobs, name) {
    "humn", _ -> True
    _, Num(_) -> False
    _, Op(_, left, right) ->
      depends_on_humn(jobs, left) || depends_on_humn(jobs, right)
  }
}

/// The value humn must take for `name` to evaluate to `target`.
fn solve_for(jobs: Dict(String, Job), name: String, target: Int) -> Int {
  case name, part1.job(jobs, name) {
    "humn", _ -> target
    _, Num(_) -> panic as "a constant has no unknown"
    _, Op(op, left, right) ->
      case depends_on_humn(jobs, left) {
        // target = x op v
        True -> {
          let v = part1.eval(jobs, right)
          solve_for(jobs, left, case op {
            "+" -> target - v
            "-" -> target + v
            "*" -> target / v
            _ -> target * v
          })
        }
        // target = v op x
        False -> {
          let v = part1.eval(jobs, left)
          solve_for(jobs, right, case op {
            "+" -> target - v
            "-" -> v - target
            "*" -> target / v
            _ -> v / target
          })
        }
      }
  }
}

pub fn solve(input: String) -> String {
  let jobs = part1.parse(input)
  let assert Op(_, left, right) = part1.job(jobs, "root")
  case depends_on_humn(jobs, left) {
    True -> solve_for(jobs, left, part1.eval(jobs, right))
    False -> solve_for(jobs, right, part1.eval(jobs, left))
  }
  |> int.to_string
}

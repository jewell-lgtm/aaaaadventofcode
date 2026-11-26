//// Same instruction stream; the fold now carries #(enabled, sum).

import gleam/int
import gleam/list
import part1.{Do, Dont, Mul}

pub fn solve(input: String) -> String {
  let #(_, sum) =
    part1.instructions(input)
    |> list.fold(#(True, 0), fn(state, instr) {
      case state, instr {
        #(_, sum), Do -> #(True, sum)
        #(_, sum), Dont -> #(False, sum)
        #(True, sum), Mul(a, b) -> #(True, sum + a * b)
        #(False, _), Mul(_, _) -> state
      }
    })
  int.to_string(sum)
}

(* Same instruction stream; now the fold carries an (enabled, sum) pair
   that do()/don't() toggle. *)
open Part1

let step (enabled, sum) = function
  | Do -> (true, sum)
  | Dont -> (false, sum)
  | Mul (a, b) -> (enabled, if enabled then sum + (a * b) else sum)

let solve input = instructions input |> List.fold_left step (true, 0) |> snd |> string_of_int

(* No more relief: keep worry bounded modulo the product of all (prime) divisors,
   which preserves every monkey's divisibility test. *)
open Part1

let modulo_all monkeys =
  let m = Array.fold_left (fun acc mk -> acc * mk.divisor) 1 monkeys in
  fun w -> w mod m

let solve input = monkey_business ~rounds:10_000 ~relief:modulo_all input |> string_of_int

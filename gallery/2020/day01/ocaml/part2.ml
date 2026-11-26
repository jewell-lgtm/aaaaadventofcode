(* Fix one entry x, then reuse part 1's pair search on the entries after it for 2020 - x.
   OCaml: pattern matching on list tails; Option.map threads the product through. *)
let rec triple_product target = function
  | [] -> None
  | x :: rest -> (
      match Part1.pair_product (target - x) rest with
      | Some p -> Some (x * p)
      | None -> triple_product target rest)

let solve input = Part1.parse input |> triple_product 2020 |> Option.get |> string_of_int

(* Report Repair: walk the list once, remembering what we've seen in an Int Set;
   stop at the first entry whose complement is already there.
   OCaml: functor-built Set.Make (Int) and a tail-recursive scan returning an option. *)
module IntSet = Set.Make (Int)

let parse input = input |> String.trim |> String.split_on_char '\n' |> List.map int_of_string

(* Product of two entries summing to [target], if any. *)
let pair_product target nums =
  let rec go seen = function
    | [] -> None
    | x :: rest ->
        let y = target - x in
        if IntSet.mem y seen then Some (x * y) else go (IntSet.add x seen) rest
  in
  go IntSet.empty nums

let solve input = parse input |> pair_product 2020 |> Option.get |> string_of_int

(* Unfold: five copies of the springs joined by '?', five copies of the groups. *)
let five x = List.init 5 (Fun.const x)
let unfold springs groups = (String.concat "?" (five springs), List.concat (five groups))
let solve input = Part1.total ~unfold input |> string_of_int

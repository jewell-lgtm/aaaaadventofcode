(* Same pair counting, 40 steps: still only ~100 distinct pairs to track. *)
let solve input = Part1.spread ~steps:40 input |> string_of_int

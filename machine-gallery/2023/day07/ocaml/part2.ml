(* Jokers: weakest for tie-breaks, wildcard for the hand type. *)
let solve input = Part1.winnings ~joker:true input |> string_of_int

(* Mull It Over: scan with one Str regex into a list of instruction variants,
   then fold. Part 1 just sums the muls and ignores do()/don't().
   OCaml: Str for the scan, a variant type so the fold is an exhaustive match. *)
type instr = Do | Dont | Mul of int * int

let instr_re = Str.regexp {|do()\|don't()\|mul(\([0-9][0-9]?[0-9]?\),\([0-9][0-9]?[0-9]?\))|}

let instructions s =
  let rec scan pos acc =
    match Str.search_forward instr_re s pos with
    | exception Not_found -> List.rev acc
    | _ ->
        let instr =
          match Str.matched_string s with
          | "do()" -> Do
          | "don't()" -> Dont
          | _ -> Mul (int_of_string (Str.matched_group 1 s), int_of_string (Str.matched_group 2 s))
        in
        scan (Str.match_end ()) (instr :: acc)
  in
  scan 0 []

let solve input =
  instructions input
  |> List.fold_left (fun sum -> function Mul (a, b) -> sum + (a * b) | Do | Dont -> sum) 0
  |> string_of_int

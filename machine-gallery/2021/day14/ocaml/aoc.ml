(* Harness helpers.
   example: true when running an example (aoc test).
   arg_int "size" 71: example-specific constant from examples.toml `args`, else the default. *)

let example = Sys.getenv_opt "AOC_EXAMPLE" = Some "1"

(* Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS. *)
let args =
  let json = Option.value (Sys.getenv_opt "AOC_ARGS") ~default:"{}" in
  let re = Str.regexp {|"\([^"]*\)"[ ]*:[ ]*\("\([^"]*\)"\|\([^,}]*\)\)|} in
  let rec go pos acc =
    match Str.search_forward re json pos with
    | exception Not_found -> List.rev acc
    | _ ->
        let key = Str.matched_group 1 json in
        let value =
          try Str.matched_group 3 json with Not_found -> String.trim (Str.matched_group 4 json)
        in
        go (Str.match_end ()) ((key, value) :: acc)
  in
  go 0 []

let arg name default = Option.value (List.assoc_opt name args) ~default
let arg_int name default = Option.fold ~none:default ~some:int_of_string (List.assoc_opt name args)

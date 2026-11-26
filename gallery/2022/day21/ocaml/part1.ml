(* Monkey Math: parse each monkey into a variant (number or binary op on two names),
   keep them in a String Map, and evaluate the tree recursively from "root".
   OCaml: variants + pattern matching read almost like the puzzle text. *)
module SMap = Map.Make (String)

type job = Num of int | Op of char * string * string

let parse_job line =
  Scanf.sscanf line "%s@: %s@\n" (fun name rest ->
      ( name,
        match String.split_on_char ' ' rest with
        | [ a; op; b ] -> Op (op.[0], a, b)
        | [ n ] -> Num (int_of_string n)
        | _ -> failwith line ))

let parse input = String.trim input |> String.split_on_char '\n' |> List.map parse_job |> SMap.of_list

let apply op a b =
  match op with '+' -> a + b | '-' -> a - b | '*' -> a * b | '/' -> a / b | _ -> failwith "op"

let rec eval jobs name =
  match SMap.find name jobs with Num n -> n | Op (op, a, b) -> apply op (eval jobs a) (eval jobs b)

let solve input = eval (parse input) "root" |> string_of_int

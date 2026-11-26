(* "humn" is the unknown. Walk down from root along the side that contains humn,
   inverting each operation against the value the other (constant) side evaluates to. *)
open Part1

let rec depends_on_humn jobs name =
  name = "humn"
  || match SMap.find name jobs with Num _ -> false | Op (_, a, b) -> depends_on_humn jobs a || depends_on_humn jobs b

(* Value humn must take for [name] to evaluate to [target]. *)
let rec solve_for jobs name target =
  if name = "humn" then target
  else
    match SMap.find name jobs with
    | Num _ -> failwith "constant has no unknown"
    | Op (op, a, b) when depends_on_humn jobs a ->
        let v = eval jobs b in
        solve_for jobs a (match op with '+' -> target - v | '-' -> target + v | '*' -> target / v | _ -> target * v)
    | Op (op, a, b) ->
        let v = eval jobs a in
        solve_for jobs b (match op with '+' -> target - v | '-' -> v - target | '*' -> target / v | _ -> v / target)

let solve input =
  let jobs = parse input in
  match SMap.find "root" jobs with
  | Op (_, a, b) when depends_on_humn jobs a -> solve_for jobs a (eval jobs b) |> string_of_int
  | Op (_, a, b) -> solve_for jobs b (eval jobs a) |> string_of_int
  | Num _ -> failwith "root must be an operation"

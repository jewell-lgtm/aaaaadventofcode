(* Extended Polymerization: never build the polymer. Track how often each adjacent pair
   occurs in a String Map; each step, pair AB with rule C becomes AC and CB.
   Element counts = first letter of every pair, plus the template's last letter. *)
module SMap = Map.Make (String)

let add key n = SMap.update key (fun old -> Some (n + Option.value old ~default:0))

let parse input =
  match String.trim input |> String.split_on_char '\n' with
  | template :: _ :: rules ->
      (template, rules |> List.map (fun r -> Scanf.sscanf r "%s -> %c" (fun pair c -> (pair, c))) |> SMap.of_list)
  | _ -> failwith "expected template, blank line, rules"

let pairs_of template =
  Seq.init (String.length template - 1) (fun i -> String.sub template i 2)
  |> Seq.fold_left (fun m p -> add p 1 m) SMap.empty

let step rules pairs =
  SMap.fold (fun pair n acc ->
      match SMap.find_opt pair rules with
      | Some c -> acc |> add (String.make 1 pair.[0] ^ String.make 1 c) n |> add (String.make 1 c ^ String.make 1 pair.[1]) n
      | None -> add pair n acc)
    pairs SMap.empty

let spread ~steps input =
  let template, rules = parse input in
  let pairs = Seq.fold_left (fun p _ -> step rules p) (pairs_of template) (Seq.init steps Fun.id) in
  let last = String.make 1 template.[String.length template - 1] in
  let counts = SMap.fold (fun pair n acc -> add (String.make 1 pair.[0]) n acc) pairs (SMap.singleton last 1) in
  let values = SMap.bindings counts |> List.map snd in
  List.fold_left max 0 values - List.fold_left min max_int values

let solve input = spread ~steps:10 input |> string_of_int

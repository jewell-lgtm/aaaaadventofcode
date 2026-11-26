(* Monkey in the Middle: parse each block into a record whose [op] is a closure,
   then simulate rounds over an array of item lists. [relief] is how worry shrinks:
   divide by 3 in part 1, reduce modulo the product of all divisors in part 2. *)
type monkey = { op : int -> int; divisor : int; if_true : int; if_false : int }

let last_int line = String.split_on_char ' ' line |> List.rev |> List.hd |> int_of_string

let parse_op line =
  match Str.split (Str.regexp " = ") line |> List.rev |> List.hd |> String.split_on_char ' ' with
  | [ "old"; "*"; "old" ] -> fun x -> x * x
  | [ "old"; "*"; n ] -> fun x -> x * int_of_string n
  | [ "old"; "+"; n ] -> fun x -> x + int_of_string n
  | _ -> failwith ("unknown operation: " ^ line)

let parse_monkey block =
  match String.split_on_char '\n' block |> List.map String.trim with
  | _ :: items :: op :: test :: if_true :: if_false :: _ ->
      let items =
        List.nth (String.split_on_char ':' items) 1
        |> String.split_on_char ',' |> List.map (fun s -> int_of_string (String.trim s))
      in
      ( items,
        { op = parse_op op; divisor = last_int test; if_true = last_int if_true; if_false = last_int if_false } )
  | _ -> failwith "bad monkey block"

let parse input = Str.split (Str.regexp "\n\n") (String.trim input) |> List.map parse_monkey

let monkey_business ~rounds ~relief input =
  let parsed = parse input in
  let monkeys = Array.of_list (List.map snd parsed) in
  let items = Array.of_list (List.map fst parsed) in
  let inspected = Array.make (Array.length monkeys) 0 in
  let relief = relief monkeys in
  let turn i m =
    items.(i) |> List.iter (fun worry ->
        let worry = relief (m.op worry) in
        let target = if worry mod m.divisor = 0 then m.if_true else m.if_false in
        items.(target) <- items.(target) @ [ worry ]);
    inspected.(i) <- inspected.(i) + List.length items.(i);
    items.(i) <- []
  in
  for _ = 1 to rounds do Array.iteri turn monkeys done;
  match Array.to_list inspected |> List.sort (Fun.flip compare) with
  | a :: b :: _ -> a * b
  | _ -> failwith "need at least two monkeys"

let solve input = monkey_business ~rounds:20 ~relief:(fun _ w -> w / 3) input |> string_of_int

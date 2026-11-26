(* Supply Stacks: read the drawing column by column into an IntMap of char lists
   (head = top crate), parse moves with Scanf, then fold the moves over the map.
   The crane is a parameter: CrateMover 9000 reverses the lifted crates, 9001 keeps them. *)
module IntMap = Map.Make (Int)

let parse_stacks drawing =
  let rows = String.split_on_char '\n' drawing |> List.rev in
  let labels, crates = (List.hd rows, List.rev (List.tl rows)) in
  let count = (String.length labels + 1) / 4 in
  let crate_at col row =
    let i = (4 * col) + 1 in
    if i < String.length row && row.[i] <> ' ' then Some row.[i] else None
  in
  List.init count (fun col -> (col + 1, List.filter_map (crate_at col) crates)) |> IntMap.of_list

let parse_move line = Scanf.sscanf line "move %d from %d to %d" (fun n src dst -> (n, src, dst))

let apply ~crane stacks (n, src, dst) =
  let from = IntMap.find src stacks in
  let lifted = List.take n from in
  stacks
  |> IntMap.add src (List.drop n from)
  |> IntMap.update dst (Option.map (List.append (crane lifted)))

let run ~crane input =
  match Str.split (Str.regexp "\n\n") input with
  | [ drawing; moves ] ->
      String.split_on_char '\n' (String.trim moves)
      |> List.map parse_move
      |> List.fold_left (apply ~crane) (parse_stacks drawing)
      |> IntMap.to_seq
      |> Seq.filter_map (fun (_, stack) -> List.nth_opt stack 0)
      |> String.of_seq
  | _ -> failwith "expected drawing and moves separated by a blank line"

let solve = run ~crane:List.rev

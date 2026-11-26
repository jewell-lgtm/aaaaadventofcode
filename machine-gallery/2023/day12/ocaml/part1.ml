(* Hot Springs: count arrangements with a DP over (position in springs, groups placed),
   memoised in a Hashtbl. At each '?' we try both '.' and the start of the next group.
   OCaml: a local recursive closure over the memo table keeps the DP self-contained. *)
let arrangements springs groups =
  let n = String.length springs in
  let groups = Array.of_list groups in
  let m = Array.length groups in
  (* Can a run of [len] damaged springs start at [i]? It needs no '.', then a non-'#' after. *)
  let fits i len =
    i + len <= n
    && not (String.contains (String.sub springs i len) '.')
    && (i + len = n || springs.[i + len] <> '#')
  in
  let memo = Hashtbl.create 256 in
  let rec count i j =
    match Hashtbl.find_opt memo (i, j) with
    | Some v -> v
    | None ->
        let operational () = count (i + 1) j in
        let damaged () = if j < m && fits i groups.(j) then count (i + groups.(j) + 1) (j + 1) else 0 in
        let v =
          if i >= n then if j = m then 1 else 0
          else match springs.[i] with '.' -> operational () | '#' -> damaged () | _ -> operational () + damaged ()
        in
        Hashtbl.add memo (i, j) v;
        v
  in
  count 0 0

let parse_line line =
  Scanf.sscanf line "%s %s" (fun springs groups ->
      (springs, String.split_on_char ',' groups |> List.map int_of_string))

let total ~unfold input =
  String.trim input |> String.split_on_char '\n' |> List.map parse_line
  |> List.map (fun (s, g) -> let s, g = unfold s g in arrangements s g)
  |> List.fold_left ( + ) 0

let solve input = total ~unfold:(fun s g -> (s, g)) input |> string_of_int

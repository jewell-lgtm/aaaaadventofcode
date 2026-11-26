(* Chiton: Dijkstra with an ordered Set of (distance, position) as the priority queue
   and an immutable Map of best-known distances. The cave is just a [risk] function,
   so part 2's tiled map is a different function, not a bigger array. *)
module Pos = struct
  type t = int * int

  let compare = compare
end

module PosMap = Map.Make (Pos)

module Queue = Set.Make (struct
  type t = int * Pos.t

  let compare = compare
end)

type cave = { width : int; height : int; risk : Pos.t -> int }

let parse input =
  let rows = String.trim input |> String.split_on_char '\n' |> Array.of_list in
  let digit (r, c) = Char.code rows.(r).[c] - Char.code '0' in
  { width = String.length rows.(0); height = Array.length rows; risk = digit }

let neighbours cave (r, c) =
  [ (r - 1, c); (r + 1, c); (r, c - 1); (r, c + 1) ]
  |> List.filter (fun (r, c) -> r >= 0 && r < cave.height && c >= 0 && c < cave.width)

let lowest_risk cave =
  let goal = (cave.height - 1, cave.width - 1) in
  let relax d (queue, best) pos =
    let d' = d + cave.risk pos in
    match PosMap.find_opt pos best with
    | Some known when known <= d' -> (queue, best)
    | _ -> (Queue.add (d', pos) queue, PosMap.add pos d' best)
  in
  let rec go queue best =
    let ((d, pos) as top) = Queue.min_elt queue in
    if pos = goal then d
    else
      let queue, best = List.fold_left (relax d) (Queue.remove top queue, best) (neighbours cave pos) in
      go queue best
  in
  go (Queue.singleton (0, (0, 0))) (PosMap.singleton (0, 0) 0)

let solve input = parse input |> lowest_risk |> string_of_int

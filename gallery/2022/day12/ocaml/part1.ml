(* Hill Climbing: level-by-level BFS over an immutable frontier list and a visited Set.
   [bfs] is generic over the step rule and goal test, so part 2 can run it backwards.
   OCaml: records, a Set.Make'd position module, and a small tail-recursive search loop. *)
module Pos = struct
  type t = int * int

  let compare = compare
end

module PosSet = Set.Make (Pos)

type grid = { rows : string array; width : int; height : int }

let parse input =
  let rows = String.trim input |> String.split_on_char '\n' |> Array.of_list in
  { rows; width = String.length rows.(0); height = Array.length rows }

let char_at g (r, c) = g.rows.(r).[c]

let height g pos =
  match char_at g pos with 'S' -> Char.code 'a' | 'E' -> Char.code 'z' | ch -> Char.code ch

let find g ch =
  let positions = Seq.product (Seq.init g.height Fun.id) (Seq.init g.width Fun.id) in
  Seq.find (fun pos -> char_at g pos = ch) positions |> Option.get

let neighbours g (r, c) =
  [ (r - 1, c); (r + 1, c); (r, c - 1); (r, c + 1) ]
  |> List.filter (fun (r, c) -> r >= 0 && r < g.height && c >= 0 && c < g.width)

(* Fewest steps from [start] to any position satisfying [goal]. *)
let bfs g ~start ~can_step ~goal =
  let rec go steps frontier seen =
    if frontier = [] then None
    else if List.exists goal frontier then Some steps
    else
      let next =
        frontier
        |> List.concat_map (fun p -> neighbours g p |> List.filter (can_step p))
        |> List.filter (fun p -> not (PosSet.mem p seen))
        |> List.sort_uniq Pos.compare
      in
      go (steps + 1) next (PosSet.union seen (PosSet.of_list next))
  in
  go 0 [ start ] (PosSet.singleton start)

let solve input =
  let g = parse input in
  let goal_pos = find g 'E' in
  bfs g ~start:(find g 'S')
    ~can_step:(fun a b -> height g b <= height g a + 1)
    ~goal:(fun p -> p = goal_pos)
  |> Option.get |> string_of_int

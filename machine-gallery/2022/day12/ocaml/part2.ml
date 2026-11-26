(* Search backwards from E (reversed step rule) until we reach any square of height 'a'. *)
open Part1

let solve input =
  let g = parse input in
  bfs g ~start:(find g 'E')
    ~can_step:(fun a b -> height g a <= height g b + 1)
    ~goal:(fun p -> height g p = Char.code 'a')
  |> Option.get |> string_of_int

(* Tile the cave 5x5: each tile step adds 1 to the risk, wrapping 9 back to 1. *)
open Part1

let tiled { width; height; risk } =
  let risk (r, c) =
    let base = risk (r mod height, c mod width) in
    ((base + (r / height) + (c / width) - 1) mod 9) + 1
  in
  { width = 5 * width; height = 5 * height; risk }

let solve input = parse input |> tiled |> lowest_risk |> string_of_int

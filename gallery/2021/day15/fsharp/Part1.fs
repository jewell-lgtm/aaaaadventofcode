/// Dijkstra with .NET's PriorityQueue and a mutable best-distance array: F# is happy to
/// be imperative inside a function when that's the fast, clear way.
module Part1

open System.Collections.Generic

type Cave = { Rows: int; Cols: int; Risk: int -> int -> int }

let parse (input: string) =
    let grid = input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries) |> Array.map (Seq.map (fun c -> int c - int '0') >> Array.ofSeq)
    { Rows = grid.Length; Cols = grid[0].Length; Risk = fun r c -> grid[r][c] }

let lowestRisk cave =
    let best = Array2D.create cave.Rows cave.Cols System.Int32.MaxValue
    let queue = PriorityQueue<struct (int * int), int>()
    best[0, 0] <- 0
    queue.Enqueue(struct (0, 0), 0)
    let mutable answer = None
    while answer.IsNone do
        let struct (r, c) = queue.Dequeue()
        let d = best[r, c]
        if (r, c) = (cave.Rows - 1, cave.Cols - 1) then answer <- Some d
        else
            for nr, nc in [ r + 1, c; r - 1, c; r, c + 1; r, c - 1 ] do
                if nr >= 0 && nr < cave.Rows && nc >= 0 && nc < cave.Cols then
                    let nd = d + cave.Risk nr nc
                    if nd < best[nr, nc] then
                        best[nr, nc] <- nd
                        queue.Enqueue(struct (nr, nc), nd)
    answer.Value

let solve (input: string) = parse input |> lowestRisk

/// BFS backwards from E as a recursive loop over a frontier list and a distance Map;
/// a step down may drop at most one. Part 2 swaps only the goal predicate.
module Part1

type Hill = { Rows: string[]; Start: int * int; End: int * int }

let parse (input: string) =
    let rows = input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries)
    let find ch =
        let r = rows |> Array.findIndex (fun row -> row.Contains(ch: char))
        r, rows[r].IndexOf ch
    { Rows = rows; Start = find 'S'; End = find 'E' }

let height hill (r, c) =
    if r < 0 || r >= hill.Rows.Length || c < 0 || c >= hill.Rows[r].Length then None
    else
        match hill.Rows[r][c] with
        | 'S' -> Some 'a'
        | 'E' -> Some 'z'
        | ch -> Some ch

/// Fewest steps from any square satisfying `goal` up to E, level by level.
let stepsFromEnd hill goal =
    let neighbours (r, c) = [ r + 1, c; r - 1, c; r, c + 1; r, c - 1 ]
    let canStep a b =
        match height hill a, height hill b with
        | Some ha, Some hb -> int ha - int hb <= 1
        | _ -> false
    let rec level steps frontier seen =
        if List.isEmpty frontier then failwith "no path"
        elif List.exists goal frontier then steps
        else
            let next =
                frontier
                |> List.collect (fun p -> neighbours p |> List.filter (fun n -> canStep p n && not (Set.contains n seen)))
                |> List.distinct
            level (steps + 1) next (Set.union seen (Set.ofList next))
    level 0 [ hill.End ] (Set.singleton hill.End)

let solve (input: string) =
    let hill = parse input
    stepsFromEnd hill ((=) hill.Start)

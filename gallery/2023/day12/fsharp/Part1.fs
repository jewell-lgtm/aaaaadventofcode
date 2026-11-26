/// Count arrangements by recursion over (index, groups left) with a match on the
/// current spring; a Dictionary memoises per row.
module Part1

open System.Collections.Generic

let arrangements (springs: string) (groups: int list) =
    let memo = Dictionary<struct (int * int), int64>()
    /// A damaged group of length n fits at i: no '.' inside and no '#' right after.
    let fits i n =
        i + n <= springs.Length
        && springs.IndexOf('.', i, n) < 0
        && (i + n = springs.Length || springs[i + n] <> '#')
    let rec count i (groups: int list) =
        let key = struct (i, groups.Length)
        match memo.TryGetValue key with
        | true, v -> v
        | _ ->
            let ways =
                if i >= springs.Length then (if groups.IsEmpty then 1L else 0L)
                else
                    let asOperational = if springs[i] <> '#' then count (i + 1) groups else 0L
                    let asGroup =
                        match groups with
                        | n :: rest when springs[i] <> '.' && fits i n -> count (i + n + 1) rest
                        | _ -> 0L
                    asOperational + asGroup
            memo[key] <- ways
            ways
    count 0 groups

let parse (input: string) =
    input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries)
    |> Array.map (fun line ->
        let parts = line.Split ' '
        parts[0], parts[1].Split ',' |> Array.map int |> List.ofArray)

let solve (input: string) = parse input |> Array.sumBy (fun (s, g) -> arrangements s g)

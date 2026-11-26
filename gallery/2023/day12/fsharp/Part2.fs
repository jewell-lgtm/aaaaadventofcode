/// Unfold each row five times; the memo keeps it fast.
module Part2

open Part1

let unfold (springs, groups) =
    String.concat "?" (List.replicate 5 springs), List.replicate 5 groups |> List.concat

let solve (input: string) =
    parse input |> Array.sumBy (unfold >> fun (s, g) -> arrangements s g)

/// Stacks are immutable lists (head = top) in an array we fold moves over; the crane is
/// a function deciding how the lifted crates land. Parsing reads the drawing by column.
module Part1

open System.Text.RegularExpressions

type Move = { Count: int; From: int; To: int }

let parse (input: string) =
    let sections = input.Split("\n\n", 2)
    let rows = sections[0].Split('\n')
    let width = rows[rows.Length - 1].Split(' ', System.StringSplitOptions.RemoveEmptyEntries).Length
    let crateAt (row: string) i =
        let col = 1 + 4 * i
        if col < row.Length && System.Char.IsLetter row[col] then Some row[col] else None
    let stacks = Array.init width (fun i -> rows[.. rows.Length - 2] |> Seq.choose (fun row -> crateAt row i) |> List.ofSeq)
    let moves =
        [ for m in Regex.Matches(sections[1], @"move (\d+) from (\d+) to (\d+)") ->
              { Count = int m.Groups[1].Value; From = int m.Groups[2].Value - 1; To = int m.Groups[3].Value - 1 } ]
    stacks, moves

/// Run every move; `land` orders the lifted crates as they end up on the target.
let operate land input =
    let stacks, moves = parse input
    let apply (s: char list[]) m =
        let lifted, rest = List.splitAt m.Count s[m.From]
        s |> Array.updateAt m.From rest |> fun s -> Array.updateAt m.To (land lifted @ s[m.To]) s
    moves |> List.fold apply stacks |> Array.map List.head |> System.String

let solve (input: string) = operate List.rev input // one at a time: order flips

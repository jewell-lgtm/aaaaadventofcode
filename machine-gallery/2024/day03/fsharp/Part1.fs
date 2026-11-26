/// Regex.Matches piped through Seq.sumBy: the regex finds the operands, a pipeline sums.
module Part1

open System.Text.RegularExpressions

let product (m: Match) = int64 m.Groups[1].Value * int64 m.Groups[2].Value

let solve (input: string) =
    Regex.Matches(input, @"mul\((\d{1,3}),(\d{1,3})\)") |> Seq.sumBy product

/// One alternation regex; fold over the tokens with a match on (token, enabled).
module Part2

open System.Text.RegularExpressions

let solve (input: string) =
    Regex.Matches(input, @"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")
    |> Seq.fold
        (fun (enabled, sum) m ->
            match m.Value, enabled with
            | "do()", _ -> true, sum
            | "don't()", _ -> false, sum
            | _, true -> true, sum + Part1.product m
            | _, false -> false, sum)
        (true, 0L)
    |> snd

/// Forty steps: pair counts stay tiny, so the same code just runs longer.
module Part2

let solve (input: string) = Part1.parse input |> Part1.spread 40

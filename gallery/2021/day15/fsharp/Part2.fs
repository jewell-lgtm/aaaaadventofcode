/// The full cave is the input tiled 5x5, risk raised per tile and wrapped 9 -> 1,
/// expressed as a new risk function over the original.
module Part2

open Part1

let tiled times cave =
    { Rows = cave.Rows * times
      Cols = cave.Cols * times
      Risk = fun r c -> (cave.Risk (r % cave.Rows) (c % cave.Cols) + r / cave.Rows + c / cave.Cols - 1) % 9 + 1 }

let solve (input: string) = parse input |> tiled 5 |> lowestRisk

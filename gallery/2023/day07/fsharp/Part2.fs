/// Jokers join the biggest real group (list pattern on the shape); J is weakest.
module Part2

open Part1

let jokerShape (cards: string) =
    let jokers = cards |> Seq.filter ((=) 'J') |> Seq.length
    match shape (cards.Replace("J", "")) with
    | top :: rest -> top + jokers :: rest
    | [] -> [ jokers ]

let solve (input: string) = parse input |> winnings jokerShape "J23456789TQKA"

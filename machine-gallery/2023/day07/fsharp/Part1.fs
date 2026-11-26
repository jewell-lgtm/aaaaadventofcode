/// Sort by a key: (shape, card strengths). F# lists and tuples compare structurally,
/// so List.sortBy needs no custom comparer at all.
module Part1

type Hand = { Cards: string; Bid: int64 }

let parse (input: string) =
    input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries)
    |> Array.map (fun line ->
        match line.Split ' ' with
        | [| cards; bid |] -> { Cards = cards; Bid = int64 bid }
        | _ -> failwithf "bad line %s" line)

/// Group sizes, largest first: [3; 2] is a full house, [1; 1; 1; 1; 1] high card.
let shape (cards: string) = cards |> Seq.countBy id |> Seq.map snd |> Seq.sortDescending |> List.ofSeq

let winnings shapeOf (order: string) hands =
    hands
    |> Array.sortBy (fun h -> shapeOf h.Cards, h.Cards |> Seq.map order.IndexOf |> List.ofSeq)
    |> Array.mapi (fun i h -> int64 (i + 1) * h.Bid)
    |> Array.sum

let solve (input: string) = parse input |> winnings shape "23456789TJQKA"

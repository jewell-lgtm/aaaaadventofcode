/// Count pairs, not the polymer: each rule AB -> C turns AB into AC and CB.
/// Pairs are char tuples; each step is a pipeline ending in a grouped sum.
module Part1

let parse (input: string) =
    match input.Trim().Split "\n\n" with
    | [| template; rules |] ->
        let rules =
            rules.Split('\n', System.StringSplitOptions.RemoveEmptyEntries)
            |> Array.map (fun l -> (l[0], l[1]), l[6])
            |> Map.ofArray
        template.Trim(), rules
    | _ -> failwith "expected template and rules"

let sumByKey pairs = pairs |> Seq.groupBy fst |> Seq.map (fun (k, vs) -> k, Seq.sumBy snd vs) |> Map.ofSeq

let step rules (pairs: Map<char * char, int64>) =
    pairs
    |> Seq.collect (fun (KeyValue((a, b), n)) ->
        match Map.tryFind (a, b) rules with
        | Some c -> [ (a, c), n; (c, b), n ]
        | None -> [ (a, b), n ])
    |> sumByKey

/// Most common element count minus least common after `steps` insertions.
let spread steps (template: string, rules) =
    let start = template |> Seq.pairwise |> Seq.map (fun p -> p, 1L) |> sumByKey
    let pairs = Seq.fold (fun ps _ -> step rules ps) start { 1..steps }
    // Every element but the template's last is the first letter of exactly one pair.
    let counts =
        Seq.append (pairs |> Seq.map (fun (KeyValue((a, _), n)) -> a, n)) [ template[template.Length - 1], 1L ]
        |> sumByKey
        |> Map.values
    Seq.max counts - Seq.min counts

let solve (input: string) = parse input |> spread 10

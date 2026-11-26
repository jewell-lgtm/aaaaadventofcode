/// Two entries summing to 2020: a recursive pass over the list carrying a Set of the
/// numbers seen so far, returning an option.
module Part1

let target = 2020

let parse (input: string) =
    input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries) |> Array.map (fun s -> int (s.Trim())) |> List.ofArray

/// Product of some a, b in nums with a + b = total.
let pairProduct (total: int) (nums: int list) : int64 option =
    let rec go seen =
        function
        | [] -> None
        | n :: _ when Set.contains (total - n) seen -> Some(int64 n * int64 (total - n))
        | n :: rest -> go (Set.add n seen) rest
    go Set.empty nums

let solve (input: string) = parse input |> pairProduct target |> Option.get

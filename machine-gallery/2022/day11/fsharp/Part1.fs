/// Each monkey block is matched line by line with an active pattern for regexes; the
/// operation becomes an int64 -> int64. The simulation uses mutable queues.
module Part1

open System.Collections.Generic
open System.Text.RegularExpressions

type Monkey = { Items: int64 list; Op: int64 -> int64; Divisor: int64; IfTrue: int; IfFalse: int }

let (|Re|_|) pattern input =
    let m = Regex.Match(input, pattern)
    if m.Success then Some [ for g in Seq.tail m.Groups -> g.Value ] else None

let parseMonkey (block: string) =
    match block.Split('\n') |> Array.map _.Trim() |> List.ofArray with
    | _ :: Re @"Starting items: (.*)" [ items ] :: Re @"new = old (.) (\w+)" [ op; operand ]
      :: Re @"(\d+)$" [ d ] :: Re @"(\d+)$" [ t ] :: Re @"(\d+)$" [ f ] :: _ ->
        let combine = if op = "*" then (*) else (+)
        { Items = items.Split ", " |> Array.map int64 |> List.ofArray
          Op = (fun old -> combine old (if operand = "old" then old else int64 operand))
          Divisor = int64 d
          IfTrue = int t
          IfFalse = int f }
    | _ -> failwithf "bad monkey: %s" block

let parse (input: string) = input.Trim().Split "\n\n" |> Array.map parseMonkey

let monkeyBusiness rounds relief (monkeys: Monkey[]) =
    let queues = monkeys |> Array.map (fun m -> Queue m.Items)
    let inspected = Array.zeroCreate<int64> monkeys.Length
    for _ in 1..rounds do
        monkeys |> Array.iteri (fun i m ->
            inspected[i] <- inspected[i] + int64 queues[i].Count
            while queues[i].Count > 0 do
                let worry = queues[i].Dequeue() |> m.Op |> relief
                queues[if worry % m.Divisor = 0L then m.IfTrue else m.IfFalse].Enqueue worry)
    inspected |> Array.sortDescending |> Array.take 2 |> Array.reduce (*)

let solve (input: string) = parse input |> monkeyBusiness 20 (fun w -> w / 3L)

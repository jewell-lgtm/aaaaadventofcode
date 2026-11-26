/// Three entries: for each number, look for a pair summing to the remainder in the tail.
module Part2

open Part1

let solve (input: string) =
    let rec go =
        function
        | [] -> failwith "no triple"
        | a :: rest ->
            match pairProduct (target - a) rest with
            | Some p -> int64 a * p
            | None -> go rest
    go (parse input)

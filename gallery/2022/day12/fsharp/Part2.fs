/// Same backwards BFS; stop at the first square of height 'a'.
module Part2

open Part1

let solve (input: string) =
    let hill = parse input
    stepsFromEnd hill (fun p -> height hill p = Some 'a')

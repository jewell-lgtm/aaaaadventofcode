// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
module Program

[<EntryPoint>]
let main _ =
    let input = stdin.ReadToEnd()
    let answer =
        if System.Environment.GetEnvironmentVariable "AOC_PART" = "2"
        then string (Part2.solve input)
        else string (Part1.solve input)
    printfn "%s" answer
    0

/// Jobs as a discriminated union; parsing matches on the split words, evaluation is
/// a recursive match. The operator is stored as the F# function itself.
module Part1

type Job =
    | Num of int64
    | Op of left: string * op: char * right: string

let parse (input: string) =
    input.Split('\n', System.StringSplitOptions.RemoveEmptyEntries)
    |> Array.map (fun line ->
        match line.Split ' ' with
        | [| name; n |] -> name.TrimEnd ':', Num(int64 n)
        | [| name; l; op; r |] -> name.TrimEnd ':', Op(l, op[0], r)
        | _ -> failwithf "bad line %s" line)
    |> Map.ofArray

let apply op (a: int64) b =
    match op with
    | '+' -> a + b
    | '-' -> a - b
    | '*' -> a * b
    | '/' -> a / b
    | _ -> failwithf "op %c" op

let rec eval (jobs: Map<string, Job>) name =
    match jobs[name] with
    | Num n -> n
    | Op(l, op, r) -> apply op (eval jobs l) (eval jobs r)

let solve (input: string) = eval (parse input) "root"

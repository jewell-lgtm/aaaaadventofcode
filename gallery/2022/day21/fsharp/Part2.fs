/// humn is the unknown. Walk from root down the side that depends on humn, inverting
/// each operation against the constant side's value.
module Part2

open Part1

let human = "humn"

let rec dependsOnHuman (jobs: Map<string, Job>) name =
    name = human
    || match jobs[name] with
       | Num _ -> false
       | Op(l, _, r) -> dependsOnHuman jobs l || dependsOnHuman jobs r

/// The value humn must shout so that monkey `name` yields `target`.
let rec solveFor jobs name target =
    if name = human then target
    else
        match jobs |> Map.find name with
        | Op(l, op, r) when dependsOnHuman jobs l -> // target = x op v
            let v = eval jobs r
            solveFor jobs l (match op with '+' -> target - v | '-' -> target + v | '*' -> target / v | _ -> target * v)
        | Op(l, op, r) -> // target = v op x
            let v = eval jobs l
            solveFor jobs r (match op with '+' -> target - v | '-' -> v - target | '*' -> target / v | _ -> v / target)
        | Num _ -> failwithf "%s is constant" name

let solve (input: string) =
    let jobs = parse input
    match jobs["root"] with
    | Op(l, _, r) when dependsOnHuman jobs l -> solveFor jobs l (eval jobs r)
    | Op(l, _, r) -> solveFor jobs r (eval jobs l)
    | Num _ -> failwith "root must be an operation"

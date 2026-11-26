/// No relief, 10,000 rounds: worry modulo the product of all divisors keeps every
/// divisibility test intact while staying inside an int64.
module Part2

open Part1

let solve (input: string) =
    let monkeys = parse input
    let modulus = monkeys |> Array.fold (fun acc m -> acc * m.Divisor) 1L
    monkeys |> monkeyBusiness 10_000 (fun w -> w % modulus)

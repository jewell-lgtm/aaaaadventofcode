## Day 11, part 2 — no relief, 10 000 rounds. Every test is divisibility, so
## worry is kept modulo the product of all divisors; a closure captures it.
## Nim's `int` is 64-bit, so squaring a reduced worry can't overflow.
import std/[sequtils, math]
import part1

proc solve*(input: string): int =
  var monkeys = parseMonkeys(input)
  let modulus = monkeys.mapIt(it.divisor).prod
  monkeys.simulate(10_000, proc(w: int): int = w mod modulus)
  monkeys.monkeyBusiness

## Day 14, part 2 — 40 steps would make a string of ~20 trillion characters,
## but pair counts stay tiny: same function, bigger number.
import part1

proc solve*(input: string): int =
  parsePolymer(input).elementSpread(40)

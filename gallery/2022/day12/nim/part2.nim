## Day 12, part 2 — the same downhill BFS from 'E'; the first square at
## elevation 'a' it reaches is the best trail start.
import std/strutils
import part1

proc solve*(input: string): int =
  input.strip.splitLines.stepsFromSummit(proc(c: char): bool = c in {'a', 'S'})

## Day 14: Extended Polymerization — never build the string; track how many
## times each adjacent pair occurs in a `CountTable[(char, char)]` and expand
## pairs per step. `largest`/`smallest` on the element tally give the answer.
import std/[strutils, strscans, tables]

type
  Pair = (char, char)
  Polymer* = object
    start: string
    rules: Table[Pair, char]

func parsePolymer*(input: string): Polymer =
  let lines = input.strip.splitLines
  result.start = lines[0]
  for line in lines[2 .. ^1]:
    var a, b, insert: char
    if line.scanf("$c$c -> $c", a, b, insert):
      result.rules[(a, b)] = insert

func step(polymer: Polymer, pairs: CountTable[Pair]): CountTable[Pair] =
  for pair, n in pairs:
    if pair in polymer.rules:
      let mid = polymer.rules[pair]
      result.inc((pair[0], mid), n)
      result.inc((mid, pair[1]), n)
    else:
      result.inc(pair, n)

func elementSpread*(polymer: Polymer, steps: int): int =
  var pairs: CountTable[Pair]
  for i in 0 ..< polymer.start.high:
    pairs.inc((polymer.start[i], polymer.start[i + 1]))
  for _ in 1 .. steps:
    pairs = polymer.step(pairs)
  # Each element is the first of exactly one pair, except the final one.
  var elements = [polymer.start[^1]].toCountTable
  for pair, n in pairs:
    elements.inc(pair[0], n)
  elements.largest.val - elements.smallest.val

proc solve*(input: string): int =
  parsePolymer(input).elementSpread(10)

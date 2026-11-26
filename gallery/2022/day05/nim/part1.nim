## Day 5: Supply Stacks — each stack is a `seq[char]` with the top at the end,
## read column-wise from the drawing; moves come from `strscans.scanf`.
## Part 1 pops crates one at a time.
import std/[strutils, strscans, algorithm]

type
  Stacks* = seq[seq[char]]
  Move* = tuple[count, src, dst: int]

func parseStacks(drawing: string): Stacks =
  let rows = drawing.splitLines
  result = newSeq[seq[char]](rows[^1].splitWhitespace.len)
  for row in rows[0 .. ^2].reversed:
    for i in 0 ..< result.len:
      let col = 1 + 4 * i
      if col < row.len and row[col] != ' ':
        result[i].add row[col]

iterator moves(procedure: string): Move =
  for line in procedure.splitLines:
    var m: Move
    if line.scanf("move $i from $i to $i", m.count, m.src, m.dst):
      yield (m.count, m.src - 1, m.dst - 1)

proc parse*(input: string): (Stacks, seq[Move]) =
  let sections = input.split("\n\n", maxsplit = 1)
  result[0] = parseStacks(sections[0])
  for m in moves(sections[1]):
    result[1].add m

func tops*(stacks: Stacks): string =
  for s in stacks:
    if s.len > 0: result.add s[^1]

proc solve*(input: string): string =
  var (stacks, plan) = parse(input)
  for m in plan:
    for _ in 1 .. m.count:
      stacks[m.dst].add stacks[m.src].pop
  stacks.tops

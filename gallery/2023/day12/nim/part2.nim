## Day 12, part 2 — unfold each record five times (springs joined by '?',
## groups repeated with `cycle`); the memoised count handles the blow-up.
import std/[strutils, sequtils]
import part1

func unfold(rec: Record): Record =
  Record(springs: newSeqWith(5, rec.springs).join("?"), groups: rec.groups.cycle(5))

proc solve*(input: string): int =
  for rec in parseRecords(input):
    result += rec.unfold.arrangements

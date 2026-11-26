## Day 1: Report Repair — a HashSet of numbers seen so far turns the pair
## search into one lookup per entry. `Option` says "maybe found" in the type;
## part 2 reuses it with an outer loop for the third number.
import std/[strutils, sequtils, sets, options]

func entries*(input: string): seq[int] =
  input.splitWhitespace.map(parseInt)

func findPair*(nums: openArray[int], target: int): Option[(int, int)] =
  var seen = initHashSet[int]()
  for n in nums:
    if target - n in seen:
      return some((target - n, n))
    seen.incl n

proc solve*(input: string): int =
  let (a, b) = entries(input).findPair(2020).get
  a * b

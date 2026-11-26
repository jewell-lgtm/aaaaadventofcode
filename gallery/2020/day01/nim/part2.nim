## Day 1, part 2 — fix each entry in turn and look for a pair summing to
## the remainder among the entries after it: O(n²) with the set-based helper.
import std/options
import part1

proc solve*(input: string): int =
  let nums = entries(input)
  for i, x in nums:
    let pair = nums[i + 1 .. ^1].findPair(2020 - x)
    if pair.isSome:
      let (a, b) = pair.get
      return x * a * b

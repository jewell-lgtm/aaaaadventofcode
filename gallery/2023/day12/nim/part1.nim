## Day 12: Hot Springs — count arrangements with a memoised recursion over
## (position, groups placed). The memo `Table` lives in the enclosing proc
## and a nested closure recurses over it: Nim's lightweight answer to @cache.
import std/[strutils, sequtils, tables]

type Record* = object
  springs*: string
  groups*: seq[int]

func parseRecords*(input: string): seq[Record] =
  for line in input.strip.splitLines:
    let parts = line.splitWhitespace
    result.add Record(springs: parts[0], groups: parts[1].split(',').map(parseInt))

func fits(springs: string, at, size: int): bool =
  ## A run of `size` damaged springs can start at `at`, followed by a gap.
  at + size <= springs.len and
    '.' notin springs[at ..< at + size] and
    (at + size == springs.len or springs[at + size] != '#')

proc arrangements*(rec: Record): int =
  var memo = initTable[(int, int), int]()
  proc count(at, group: int): int =
    if at >= rec.springs.len:
      return ord(group == rec.groups.len)
    if (at, group) in memo:
      return memo[(at, group)]
    let c = rec.springs[at]
    if c in {'.', '?'}:
      result += count(at + 1, group)
    if c in {'#', '?'} and group < rec.groups.len and
        rec.springs.fits(at, rec.groups[group]):
      result += count(at + rec.groups[group] + 1, group + 1)
    memo[(at, group)] = result
  count(0, 0)

proc solve*(input: string): int =
  for rec in parseRecords(input):
    result += rec.arrangements

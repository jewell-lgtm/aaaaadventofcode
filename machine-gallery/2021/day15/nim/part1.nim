## Day 15: Chiton — Dijkstra over the grid with `std/heapqueue` (a min-heap
## of `(risk, pos)` tuples, which compare lexicographically for free).
## The `Cave` object computes risk for any tile, so part 2 just changes `tiles`.
import std/[strutils, sequtils, heapqueue]

type
  Pos = tuple[r, c: int]
  Cave* = object
    cells: seq[seq[int]]
    tiles*: int

func parseCave*(input: string, tiles = 1): Cave =
  for line in input.strip.splitLines:
    result.cells.add line.mapIt(ord(it) - ord('0'))
  result.tiles = tiles

func height(cave: Cave): int = cave.cells.len * cave.tiles
func width(cave: Cave): int = cave.cells[0].len * cave.tiles

func risk(cave: Cave, p: Pos): int =
  ## Each tile step right or down adds 1, wrapping 9 back to 1.
  let (h, w) = (cave.cells.len, cave.cells[0].len)
  let raw = cave.cells[p.r mod h][p.c mod w] + p.r div h + p.c div w
  (raw - 1) mod 9 + 1

iterator neighbours(cave: Cave, p: Pos): Pos =
  for (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
    let q: Pos = (p.r + dr, p.c + dc)
    if q.r in 0 ..< cave.height and q.c in 0 ..< cave.width:
      yield q

func lowestTotalRisk*(cave: Cave): int =
  let goal: Pos = (cave.height - 1, cave.width - 1)
  var best = newSeqWith(cave.height, newSeqWith(cave.width, int.high))
  var frontier = [(0, (r: 0, c: 0))].toHeapQueue
  best[0][0] = 0
  while frontier.len > 0:
    let (total, p) = frontier.pop
    if p == goal: return total
    if total > best[p.r][p.c]: continue   # stale heap entry
    for q in cave.neighbours(p):
      let next = total + cave.risk(q)
      if next < best[q.r][q.c]:
        best[q.r][q.c] = next
        frontier.push (next, q)

proc solve*(input: string): int =
  parseCave(input).lowestTotalRisk

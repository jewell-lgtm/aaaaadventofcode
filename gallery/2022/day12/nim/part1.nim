## Day 12: Hill Climbing — breadth-first search from the summit *downhill*,
## so both parts are one BFS with a different "found it" predicate.
## Nim bits: a neighbour iterator, `std/deques` as the queue, `case` on chars.
import std/[strutils, deques, tables]

type
  Grid* = seq[string]
  Pos = tuple[r, c: int]

func elevation(c: char): int =
  case c
  of 'S': ord('a')
  of 'E': ord('z')
  else: ord(c)

func locate(grid: Grid, ch: char): Pos =
  for r, row in grid:
    let c = row.find(ch)
    if c >= 0: return (r, c)

iterator neighbours(grid: Grid, p: Pos): Pos =
  for (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
    let q: Pos = (p.r + dr, p.c + dc)
    if q.r in 0 ..< grid.len and q.c in 0 ..< grid[q.r].len:
      yield q

proc stepsFromSummit*(grid: Grid, isStart: proc(c: char): bool): int =
  ## Shortest climb from any square satisfying `isStart` to 'E'.
  ## Reversed edge q <- p is legal when climbing q -> p rises at most one.
  let summit = grid.locate('E')
  var dist = {summit: 0}.toTable
  var queue = [summit].toDeque
  while queue.len > 0:
    let p = queue.popFirst
    if isStart(grid[p.r][p.c]): return dist[p]
    for q in grid.neighbours(p):
      if q notin dist and elevation(grid[p.r][p.c]) - elevation(grid[q.r][q.c]) <= 1:
        dist[q] = dist[p] + 1
        queue.addLast q
  -1

proc solve*(input: string): int =
  input.strip.splitLines.stepsFromSummit(proc(c: char): bool = c == 'S')

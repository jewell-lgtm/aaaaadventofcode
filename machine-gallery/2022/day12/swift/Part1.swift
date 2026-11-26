// BFS from E going downhill (edges reversed) until we reach S.
// A Hashable Point keys the distance dictionary; an array + head index is the queue.
struct Point: Hashable { var r, c: Int }

func solve(_ input: String) -> any CustomStringConvertible {
  var grid = input.split(separator: "\n").map { Array($0.utf8) }
  var start = Point(r: 0, c: 0)
  var end = start
  for r in grid.indices {
    for c in grid[r].indices {
      switch grid[r][c] {
      case UInt8(ascii: "S"): (start, grid[r][c]) = (Point(r: r, c: c), UInt8(ascii: "a"))
      case UInt8(ascii: "E"): (end, grid[r][c]) = (Point(r: r, c: c), UInt8(ascii: "z"))
      default: break
      }
    }
  }
  return stepsFromEnd(grid, end) { $0 == start } ?? -1
}

func stepsFromEnd(_ grid: [[UInt8]], _ end: Point, until done: (Point) -> Bool) -> Int? {
  var dist = [end: 0]
  var queue = [end]
  var head = 0
  while head < queue.count {
    let p = queue[head]
    head += 1
    if done(p) { return dist[p] }
    let neighbours = [
      Point(r: p.r - 1, c: p.c), Point(r: p.r + 1, c: p.c),
      Point(r: p.r, c: p.c - 1), Point(r: p.r, c: p.c + 1),
    ]
    for q in neighbours
    where grid.indices.contains(q.r) && grid[q.r].indices.contains(q.c)
      && dist[q] == nil && grid[p.r][p.c] <= grid[q.r][q.c] + 1
    {
      dist[q] = dist[p]! + 1
      queue.append(q)
    }
  }
  return nil
}

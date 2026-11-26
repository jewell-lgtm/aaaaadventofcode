// Dijkstra over the input tiled 5×5, with risk computed on the fly. Swift's standard
// library has no priority queue, so a small generic binary Heap is included.
func solve(_ input: String) -> any CustomStringConvertible {
  lowestTotalRisk(input, tiles: 5)
}

struct State: Comparable {
  let risk: Int, pos: Int
  static func < (a: State, b: State) -> Bool { a.risk < b.risk }
}

func lowestTotalRisk(_ input: String, tiles: Int) -> Int {
  let cave = input.split(separator: "\n").map { $0.compactMap(\.wholeNumberValue) }
  let (h, w) = (cave.count, cave[0].count)
  let (rows, cols) = (h * tiles, w * tiles)
  func risk(_ r: Int, _ c: Int) -> Int { (cave[r % h][c % w] + r / h + c / w - 1) % 9 + 1 }

  var dist = [Int](repeating: .max, count: rows * cols)
  dist[0] = 0
  var heap = Heap<State>()
  heap.push(State(risk: 0, pos: 0))
  while let cur = heap.pop() {
    if cur.pos == rows * cols - 1 { return cur.risk }
    if cur.risk > dist[cur.pos] { continue }
    let (r, c) = cur.pos.quotientAndRemainder(dividingBy: cols)
    for (nr, nc) in [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)]
    where (0..<rows).contains(nr) && (0..<cols).contains(nc) {
      let next = State(risk: cur.risk + risk(nr, nc), pos: nr * cols + nc)
      if next.risk < dist[next.pos] {
        dist[next.pos] = next.risk
        heap.push(next)
      }
    }
  }
  fatalError("bottom-right is unreachable")
}

/// Minimal binary min-heap.
struct Heap<Element: Comparable> {
  private var items: [Element] = []

  mutating func push(_ x: Element) {
    items.append(x)
    var i = items.count - 1
    while i > 0, items[i] < items[(i - 1) / 2] {
      items.swapAt(i, (i - 1) / 2)
      i = (i - 1) / 2
    }
  }

  mutating func pop() -> Element? {
    guard !items.isEmpty else { return nil }
    items.swapAt(0, items.count - 1)
    let top = items.removeLast()
    var i = 0
    while true {
      let (l, r) = (2 * i + 1, 2 * i + 2)
      var smallest = i
      if l < items.count, items[l] < items[smallest] { smallest = l }
      if r < items.count, items[r] < items[smallest] { smallest = r }
      if smallest == i { return top }
      items.swapAt(i, smallest)
      i = smallest
    }
  }
}

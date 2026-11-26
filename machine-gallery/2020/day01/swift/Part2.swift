// Three-sum: sort once, then two pointers for each first entry.
// `switch` with range patterns (..<2020) spells out the three cases of the sweep.
func solve(_ input: String) -> any CustomStringConvertible {
  let entries = input.split(whereSeparator: \.isWhitespace).compactMap { Int($0) }.sorted()
  for (i, a) in entries.enumerated() {
    var (lo, hi) = (i + 1, entries.count - 1)
    while lo < hi {
      switch a + entries[lo] + entries[hi] {
      case 2020: return a * entries[lo] * entries[hi]
      case ..<2020: lo += 1
      default: hi -= 1
      }
    }
  }
  fatalError("no triple sums to 2020")
}

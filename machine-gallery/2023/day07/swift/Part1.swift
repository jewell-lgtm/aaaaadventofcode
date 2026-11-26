// A Comparable Hand struct: compare the card-count shape ([3, 2] = full house) first,
// then card values. Dictionary(grouping:by:) does the counting in one expression.
let order = Array("23456789TJQKA")

struct Hand: Comparable {
  let shape: [Int], values: [Int], bid: Int

  init(_ line: Substring) {
    let parts = line.split(separator: " ")
    shape = Dictionary(grouping: parts[0], by: { $0 }).values.map(\.count).sorted(by: >)
    values = parts[0].map { order.firstIndex(of: $0)! }
    bid = Int(parts[1])!
  }

  static func < (a: Hand, b: Hand) -> Bool {
    a.shape != b.shape
      ? a.shape.lexicographicallyPrecedes(b.shape)
      : a.values.lexicographicallyPrecedes(b.values)
  }
}

func solve(_ input: String) -> any CustomStringConvertible {
  let hands = input.split(separator: "\n").map(Hand.init).sorted()
  return hands.enumerated().reduce(0) { sum, entry in sum + (entry.offset + 1) * entry.element.bid }
}

// Jokers: J ranks lowest for ties but joins the largest group when typing a hand.
// Same Comparable Hand; only the shape calculation changes.
let order = Array("J23456789TQKA")

struct Hand: Comparable {
  let shape: [Int], values: [Int], bid: Int

  init(_ line: Substring) {
    let parts = line.split(separator: " ")
    let cards = parts[0]
    let jokers = cards.filter { $0 == "J" }.count
    var counts = Dictionary(grouping: cards.filter { $0 != "J" }, by: { $0 }).values.map(\.count)
      .sorted(by: >)
    if counts.isEmpty { counts = [0] }  // JJJJJ
    counts[0] += jokers
    shape = counts
    values = cards.map { order.firstIndex(of: $0)! }
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

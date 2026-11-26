// Two-sum with a Set: for each entry, check whether its complement was already seen.
// compactMap(Int.init) parses and drops anything that isn't a number in one step.
func solve(_ input: String) -> any CustomStringConvertible {
  var seen = Set<Int>()
  for n in input.split(whereSeparator: \.isWhitespace).compactMap({ Int($0) }) {
    if seen.contains(2020 - n) { return n * (2020 - n) }
    seen.insert(n)
  }
  fatalError("no pair sums to 2020")
}

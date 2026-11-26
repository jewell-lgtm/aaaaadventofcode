// 40 steps would build ~20 trillion elements; pair counts stay tiny. Dictionary's
// `default:` subscript makes the counting a one-liner per pair.
func solve(_ input: String) -> any CustomStringConvertible {
  polymerStrength(input, steps: 40)
}

func polymerStrength(_ input: String, steps: Int) -> Int {
  let sections = input.split(separator: "\n\n")
  let template = Array(sections[0])
  var rules: [String: Character] = [:]
  for line in sections[1].split(separator: "\n") {
    let parts = line.split(separator: " -> ")
    rules[String(parts[0])] = parts[1].first!
  }

  var pairs: [String: Int] = [:]
  for (a, b) in zip(template, template.dropFirst()) { pairs[String([a, b]), default: 0] += 1 }
  for _ in 0..<steps {
    var next: [String: Int] = [:]
    for (pair, n) in pairs {
      if let c = rules[pair] {
        next[String([pair.first!, c]), default: 0] += n
        next[String([c, pair.last!]), default: 0] += n
      } else {
        next[pair, default: 0] += n
      }
    }
    pairs = next
  }

  // Every element is the first letter of exactly one pair, except the last one.
  var counts: [Character: Int] = [template.last!: 1]
  for (pair, n) in pairs { counts[pair.first!, default: 0] += n }
  return counts.values.max()! - counts.values.min()!
}

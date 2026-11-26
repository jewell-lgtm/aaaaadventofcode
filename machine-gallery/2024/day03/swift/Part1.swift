// Regex literal with typed captures: each match is (Substring, Substring, Substring),
// so the reduce reads the two numbers by tuple position with no group lookups.
func solve(_ input: String) -> any CustomStringConvertible {
  let mul = /mul\((\d{1,3}),(\d{1,3})\)/
  return input.matches(of: mul).reduce(0) { sum, m in sum + Int(m.1)! * Int(m.2)! }
}

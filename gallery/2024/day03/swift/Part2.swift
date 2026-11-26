// One alternation regex finds mul/do/don't in order. With alternation the captures
// become optionals, which `if let` unwraps only for the mul branch.
func solve(_ input: String) -> any CustomStringConvertible {
  let instruction = /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/
  var enabled = true
  var total = 0
  for m in input.matches(of: instruction) {
    switch m.0 {
    case "do()": enabled = true
    case "don't()": enabled = false
    default:
      if enabled, let a = m.1, let b = m.2 { total += Int(a)! * Int(b)! }
    }
  }
  return total
}

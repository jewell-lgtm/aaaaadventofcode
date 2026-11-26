// humn appears once in the tree. Walk from root towards it, inverting each
// operation against the value of the other (fully known) subtree.
enum Job {
  case number(Int)
  case math(String, Character, String)
}

func solve(_ input: String) -> any CustomStringConvertible {
  let jobs = parse(input)

  func eval(_ name: String) -> Int {
    switch jobs[name]! {
    case .number(let n): return n
    case .math(let a, let op, let b):
      let (x, y) = (eval(a), eval(b))
      switch op {
      case "+": return x + y
      case "-": return x - y
      case "*": return x * y
      default: return x / y
      }
    }
  }

  func hasHuman(_ name: String) -> Bool {
    if name == "humn" { return true }
    guard case .math(let a, _, let b) = jobs[name]! else { return false }
    return hasHuman(a) || hasHuman(b)
  }

  /// The humn value that makes the subtree at `name` evaluate to `target`.
  func solveFor(_ name: String, _ target: Int) -> Int {
    guard name != "humn", case .math(let a, let op, let b) = jobs[name]! else { return target }
    if hasHuman(a) {
      let known = eval(b)
      switch op {
      case "+": return solveFor(a, target - known)
      case "-": return solveFor(a, target + known)
      case "*": return solveFor(a, target / known)
      default: return solveFor(a, target * known)
      }
    } else {
      let known = eval(a)
      switch op {
      case "+": return solveFor(b, target - known)
      case "-": return solveFor(b, known - target)
      case "*": return solveFor(b, target / known)
      default: return solveFor(b, known / target)
      }
    }
  }

  guard case .math(let a, _, let b) = jobs["root"]! else { fatalError("root must be an operation") }
  return hasHuman(a) ? solveFor(a, eval(b)) : solveFor(b, eval(a))
}

func parse(_ input: String) -> [String: Job] {
  var jobs: [String: Job] = [:]
  for line in input.split(separator: "\n") {
    let words = line.split(separator: " ")
    let name = String(words[0].dropLast())
    jobs[name] =
      words.count == 4
      ? .math(String(words[1]), words[2].first!, String(words[3]))
      : .number(Int(words[1])!)
  }
  return jobs
}

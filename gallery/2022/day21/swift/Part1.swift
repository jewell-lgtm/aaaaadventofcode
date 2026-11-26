// The monkeys are an expression tree: an enum with associated values, evaluated
// recursively with `switch`. Operators are stored as functions, picked at parse time.
enum Job {
  case number(Int)
  case math(String, (Int, Int) -> Int, String)
}

func solve(_ input: String) -> any CustomStringConvertible {
  let jobs = parse(input)
  func eval(_ name: String) -> Int {
    switch jobs[name]! {
    case .number(let n): n
    case .math(let a, let op, let b): op(eval(a), eval(b))
    }
  }
  return eval("root")
}

func parse(_ input: String) -> [String: Job] {
  let ops: [Substring: (Int, Int) -> Int] = ["+": (+), "-": (-), "*": (*), "/": (/)]
  var jobs: [String: Job] = [:]
  for line in input.split(separator: "\n") {
    let words = line.split(separator: " ")
    let name = String(words[0].dropLast())
    jobs[name] =
      words.count == 4
      ? .math(String(words[1]), ops[words[2]]!, String(words[3]))
      : .number(Int(words[1])!)
  }
  return jobs
}

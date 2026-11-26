// No relief, 10000 rounds: keep worry modulo the product of all divisors, which keeps
// every divisibility test intact and the numbers inside Int.
enum Operation {
  case add(Int)
  case multiply(Int)
  case square

  func apply(_ old: Int) -> Int {
    switch self {
    case .add(let n): old + n
    case .multiply(let n): old * n
    case .square: old * old
    }
  }
}

struct Monkey {
  var items: [Int]
  let operation: Operation
  let divisor, ifTrue, ifFalse: Int
}

func solve(_ input: String) -> any CustomStringConvertible {
  let monkeys = parseMonkeys(input)
  let modulus = monkeys.map(\.divisor).reduce(1, *)
  return monkeyBusiness(monkeys, rounds: 10_000) { $0 % modulus }
}

func parseMonkeys(_ input: String) -> [Monkey] {
  input.split(separator: "\n\n").map { block in
    let lines = block.split(separator: "\n").map { $0.split(separator: " ") }
    let lastNumber = { (i: Int) in Int(lines[i].last!)! }
    let operation: Operation =
      switch (lines[2][4], lines[2][5]) {
      case ("*", "old"): .square
      case ("*", let n): .multiply(Int(n)!)
      case (_, let n): .add(Int(n)!)
      }
    return Monkey(
      items: lines[1].dropFirst(2).compactMap { Int($0.filter(\.isNumber)) },
      operation: operation, divisor: lastNumber(3), ifTrue: lastNumber(4), ifFalse: lastNumber(5))
  }
}

func monkeyBusiness(_ monkeys: [Monkey], rounds: Int, relief: (Int) -> Int) -> Int {
  var monkeys = monkeys
  var inspected = [Int](repeating: 0, count: monkeys.count)
  for _ in 0..<rounds {
    for i in monkeys.indices {
      let m = monkeys[i]
      monkeys[i].items.removeAll()
      inspected[i] += m.items.count
      for item in m.items {
        let worry = relief(m.operation.apply(item))
        monkeys[worry % m.divisor == 0 ? m.ifTrue : m.ifFalse].items.append(worry)
      }
    }
  }
  let top = inspected.sorted(by: >)
  return top[0] * top[1]
}

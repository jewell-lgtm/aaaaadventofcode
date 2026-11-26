// The CrateMover 9001 lifts several crates at once: append the suffix, then drop it.
struct Move { let count, from, to: Int }

func solve(_ input: String) -> any CustomStringConvertible {
  var (stacks, moves) = parse(input)
  for m in moves {
    stacks[m.to] += stacks[m.from].suffix(m.count)
    stacks[m.from].removeLast(m.count)
  }
  return String(stacks.compactMap(\.last))
}

func parse(_ input: String) -> ([[Character]], [Move]) {
  let sections = input.split(separator: "\n\n", maxSplits: 1)
  let rows = sections[0].split(separator: "\n").map(Array.init)
  let stackCount = rows.last!.split(separator: " ").count

  var stacks = [[Character]](repeating: [], count: stackCount)
  for row in rows.dropLast().reversed() {
    for i in stacks.indices where 1 + 4 * i < row.count && row[1 + 4 * i] != " " {
      stacks[i].append(row[1 + 4 * i])
    }
  }

  let moves = sections[1].split(separator: "\n").map { line in
    let n = line.split(separator: " ").compactMap { Int($0) }
    return Move(count: n[0], from: n[1] - 1, to: n[2] - 1)
  }
  return (stacks, moves)
}

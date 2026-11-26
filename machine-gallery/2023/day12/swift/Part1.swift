// Memoised recursion over (position, group index). Nested functions capture the
// memo table by reference, so the recursion reads like the plain definition.
func solve(_ input: String) -> any CustomStringConvertible {
  input.split(separator: "\n").reduce(0) { total, line in
    let parts = line.split(separator: " ")
    let springs = Array(parts[0])
    let groups = parts[1].split(separator: ",").map { Int($0)! }
    return total + arrangements(springs, groups)
  }
}

func arrangements(_ springs: [Character], _ groups: [Int]) -> Int {
  var memo = [[Int?]](
    repeating: [Int?](repeating: nil, count: groups.count + 1), count: springs.count)

  /// Can a run of n damaged springs start at i (and be followed by a gap)?
  func fits(_ i: Int, _ n: Int) -> Bool {
    i + n <= springs.count && !springs[i..<i + n].contains(".")
      && (i + n == springs.count || springs[i + n] != "#")
  }

  func count(_ i: Int, _ g: Int) -> Int {
    if i >= springs.count { return g == groups.count ? 1 : 0 }
    if let cached = memo[i][g] { return cached }
    var ways = 0
    if springs[i] != "#" { ways += count(i + 1, g) }  // operational
    if springs[i] != ".", g < groups.count, fits(i, groups[g]) {
      ways += count(i + groups[g] + 1, g + 1)  // start a damaged run here
    }
    memo[i][g] = ways
    return ways
  }

  return count(0, 0)
}

// Three entries: the same search with k = 3 (C(200, 3) ≈ 1.3M combinations, still fast).
object Part2:
  def solve(input: String): Any = Part1.productOfSum(Part1.parse(input), 3)

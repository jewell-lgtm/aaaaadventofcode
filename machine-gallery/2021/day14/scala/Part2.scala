// Forty steps: pair counts stay tiny, so the same code just runs longer.
object Part2:
  def solve(input: String): Any = Part1.spread(Part1.parse(input), 40)

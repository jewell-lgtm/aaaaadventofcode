// Unfold each row five times; memoisation keeps it fast.
object Part2:
  def solve(input: String): Any = Part1.parse(input).map(_.unfold(5).arrangements).sum

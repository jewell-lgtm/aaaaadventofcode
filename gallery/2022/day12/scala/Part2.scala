// Same backwards BFS; stop at the first square of height 'a'.
object Part2:
  def solve(input: String): Any =
    val hill = Part1.parse(input)
    hill.stepsFromEnd(p => hill.height(p).contains('a'))

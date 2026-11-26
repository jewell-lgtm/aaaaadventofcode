// CrateMover 9001 moves the block as is.
object Part2:
  def solve(input: String): Any = Part1.operate(input)(identity)

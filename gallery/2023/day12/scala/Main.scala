// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
object Main:
  def main(args: Array[String]): Unit =
    val input = String(System.in.readAllBytes())
    println(if sys.env.get("AOC_PART").contains("2") then Part2.solve(input) else Part1.solve(input))

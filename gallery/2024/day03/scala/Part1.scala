// `findAllMatchIn` yields each match with its groups; multiply them and sum.
object Part1:
  val Mul = """mul\((\d{1,3}),(\d{1,3})\)""".r

  def solve(input: String): Any =
    Mul.findAllMatchIn(input).map(m => m.group(1).toLong * m.group(2).toLong).sum

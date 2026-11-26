// Tokenise with one alternation regex, then foldLeft over (enabled, sum),
// matching each token against regex extractors and literals.
object Part2:
  val Token = """mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)""".r
  val Mul = """mul\((\d+),(\d+)\)""".r

  def solve(input: String): Any =
    val (_, sum) = Token.findAllIn(input).foldLeft((true, 0L)) {
      case ((_, sum), "do()")             => (true, sum)
      case ((_, sum), "don't()")          => (false, sum)
      case ((true, sum), Mul(a, b))       => (true, sum + a.toLong * b.toLong)
      case (state, _)                     => state
    }
    sum

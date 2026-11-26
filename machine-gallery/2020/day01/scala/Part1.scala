// Two entries summing to 2020: `combinations(2)` over the list and `collectFirst`.
// Quadratic, but the input is 200 numbers and the code is the problem statement.
object Part1:
  val Target = 2020

  def parse(input: String): Vector[Int] = input.linesIterator.filter(_.nonEmpty).map(_.trim.toInt).toVector

  /** Product of the first `k` entries that sum to the target. */
  def productOfSum(nums: Vector[Int], k: Int): Long =
    nums.combinations(k).collectFirst { case c if c.sum == Target => c.map(_.toLong).product }.get

  def solve(input: String): Any = productOfSum(parse(input), 2)

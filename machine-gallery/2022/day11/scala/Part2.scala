// No relief, 10,000 rounds: worry modulo the product of all divisors keeps every
// divisibility test intact while staying inside a Long.
object Part2:
  def solve(input: String): Any =
    val monkeys = Part1.parse(input)
    val modulus = monkeys.map(_.divisor).product
    Part1.monkeyBusiness(monkeys, 10_000, _ % modulus)

// No relief and 10,000 rounds: worry modulo the product of all divisors keeps every
// divisibility test intact while staying inside a Long.
package part2

import part1.monkeyBusiness
import part1.parse

fun solve(input: String): Any {
    val monkeys = parse(input)
    val modulus = monkeys.map { it.divisor }.reduce(Long::times)
    return monkeyBusiness(monkeys, 10_000) { it % modulus }
}

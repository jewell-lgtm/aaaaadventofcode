// One alternation regex, folded left-to-right over (enabled, sum) with a when on the token.
package part2

import part1.product

val TOKEN = Regex("""mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)""")

fun solve(input: String): Any =
    TOKEN.findAll(input).fold(true to 0L) { (enabled, sum), m ->
        when (m.value) {
            "do()" -> true to sum
            "don't()" -> false to sum
            else -> enabled to if (enabled) sum + product(m) else sum
        }
    }.second

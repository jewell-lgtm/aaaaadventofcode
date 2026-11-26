// Forty steps: pair counts stay tiny, so the same code just runs longer.
package part2

import part1.parse
import part1.spread

fun solve(input: String): Any = parse(input).spread(40)

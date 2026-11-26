// Same backwards BFS; stop at the first square of height 'a'.
package part2

import part1.parse

fun solve(input: String): Any {
    val hill = parse(input)
    return hill.stepsFromEnd { hill.height(it) == 'a' }
}

// CrateMover 9001 lifts the top `count` crates as one block, keeping their order.
package part2

import part1.operate

fun solve(input: String): Any = operate(input) { from, to, count ->
    val lifted = List(count) { from.removeFirst() }
    lifted.asReversed().forEach(to::addFirst)
}

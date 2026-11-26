// The full map is the input tiled 5x5, risk raised per tile and wrapped 9 -> 1.
// Expressed as a view over the original cave rather than a new grid.
package part2

import part1.Cave
import part1.Pos
import part1.lowestRisk
import part1.parse

fun Cave.tiled(times: Int) = Cave(rows * times, cols * times) { (r, c) ->
    (risk(Pos(r % rows, c % cols)) + r / rows + c / cols - 1) % 9 + 1
}

fun solve(input: String): Any = lowestRisk(parse(input).tiled(5))

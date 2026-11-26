// Dijkstra with java.util.PriorityQueue over Pair(dist, pos), stale entries skipped.
// The grid is a lookup function, so part 2 can pass a tiled view without copying.
package part1

import java.util.PriorityQueue

data class Pos(val r: Int, val c: Int)

class Cave(val rows: Int, val cols: Int, val risk: (Pos) -> Int)

fun parse(input: String): Cave {
    val grid = input.lines().filter { it.isNotEmpty() }.map { line -> line.map { it.digitToInt() } }
    return Cave(grid.size, grid[0].size) { (r, c) -> grid[r][c] }
}

fun lowestRisk(cave: Cave): Int {
    val goal = Pos(cave.rows - 1, cave.cols - 1)
    val best = mutableMapOf(Pos(0, 0) to 0)
    val queue = PriorityQueue<Pair<Int, Pos>>(compareBy { it.first })
    queue += 0 to Pos(0, 0)
    while (queue.isNotEmpty()) {
        val (d, p) = queue.poll()
        if (p == goal) return d
        if (d > best.getValue(p)) continue
        for (n in listOf(Pos(p.r + 1, p.c), Pos(p.r - 1, p.c), Pos(p.r, p.c + 1), Pos(p.r, p.c - 1))) {
            if (n.r !in 0..<cave.rows || n.c !in 0..<cave.cols) continue
            val nd = d + cave.risk(n)
            if (nd < (best[n] ?: Int.MAX_VALUE)) {
                best[n] = nd
                queue += nd to n
            }
        }
    }
    error("unreachable")
}

fun solve(input: String): Any = lowestRisk(parse(input))

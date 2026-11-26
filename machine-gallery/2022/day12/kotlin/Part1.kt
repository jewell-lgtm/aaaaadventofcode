// Breadth-first search backwards from E over a List<String> grid: a step down may
// drop at most one. Part 2 is the same search with a different goal predicate.
package part1

data class Pos(val r: Int, val c: Int) {
    fun neighbours() = listOf(Pos(r + 1, c), Pos(r - 1, c), Pos(r, c + 1), Pos(r, c - 1))
}

class Hill(private val rows: List<String>) {
    private fun find(ch: Char) = rows.withIndex().firstNotNullOf { (r, row) -> row.indexOf(ch).takeIf { it >= 0 }?.let { Pos(r, it) } }
    val start = find('S')
    val end = find('E')

    fun height(p: Pos): Char? = when (val ch = rows.getOrNull(p.r)?.getOrNull(p.c)) {
        'S' -> 'a'
        'E' -> 'z'
        else -> ch
    }

    /** Fewest steps from any square satisfying goal up to E. */
    fun stepsFromEnd(goal: (Pos) -> Boolean): Int {
        val dist = mutableMapOf(end to 0)
        val queue = ArrayDeque(listOf(end))
        while (queue.isNotEmpty()) {
            val cur = queue.removeFirst()
            if (goal(cur)) return dist.getValue(cur)
            for (next in cur.neighbours()) {
                val h = height(next) ?: continue
                if (next !in dist && height(cur)!! - h <= 1) {
                    dist[next] = dist.getValue(cur) + 1
                    queue.addLast(next)
                }
            }
        }
        error("no path")
    }
}

fun parse(input: String) = Hill(input.lines().filter { it.isNotEmpty() })

fun solve(input: String): Any {
    val hill = parse(input)
    return hill.stepsFromEnd { it == hill.start }
}

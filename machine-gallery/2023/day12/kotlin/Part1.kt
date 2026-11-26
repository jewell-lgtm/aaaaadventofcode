// Memoised recursion over (spring index, groups placed), cached in a HashMap via
// getOrPut. Each branch is one choice for the current spring.
package part1

class Row(private val springs: String, private val groups: List<Int>) {
    private val memo = HashMap<Pair<Int, Int>, Long>()

    fun arrangements(i: Int = 0, g: Int = 0): Long = memo.getOrPut(i to g) {
        if (i >= springs.length) return@getOrPut if (g == groups.size) 1 else 0
        val ch = springs[i]
        val asOperational = if (ch != '#') arrangements(i + 1, g) else 0
        val asGroup = if (ch != '.' && g < groups.size && fits(i, groups[g])) arrangements(i + groups[g] + 1, g + 1) else 0
        asOperational + asGroup
    }

    /** A damaged group of length n can start at i: no '.' inside and no '#' right after. */
    private fun fits(i: Int, n: Int) =
        i + n <= springs.length && '.' !in springs.substring(i, i + n) && springs.getOrNull(i + n) != '#'

    fun unfolded(times: Int) = Row(List(times) { springs }.joinToString("?"), List(times) { groups }.flatten())

    companion object {
        fun parse(line: String): Row {
            val (springs, groups) = line.split(" ")
            return Row(springs, groups.split(",").map(String::toInt))
        }
    }
}

fun rows(input: String) = input.lines().filter { it.isNotBlank() }.map(Row::parse)

fun solve(input: String): Any = rows(input).sumOf { it.arrangements() }

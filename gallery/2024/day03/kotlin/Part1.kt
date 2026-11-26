// Regex.findAll yields a lazy sequence of matches; destructure the groups and sum.
package part1

val MUL = Regex("""mul\((\d{1,3}),(\d{1,3})\)""")

fun product(m: MatchResult): Long {
    val (a, b) = m.destructured
    return a.toLong() * b.toLong()
}

fun solve(input: String): Any = MUL.findAll(input).sumOf(::product)

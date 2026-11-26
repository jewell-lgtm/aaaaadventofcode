// Count pairs, not the polymer: each rule AB -> C turns every AB into AC and CB.
// Map<String, Long> updated with groupingBy/fold each step.
package part1

class Polymer(val template: String, val rules: Map<String, Char>)

fun parse(input: String): Polymer {
    val (template, rules) = input.trim().split("\n\n")
    return Polymer(template.trim(), rules.lines().filter { it.isNotBlank() }.associate {
        val (pair, insert) = it.split(" -> ")
        pair to insert[0]
    })
}

fun Polymer.step(pairs: Map<String, Long>): Map<String, Long> =
    pairs.flatMap { (pair, n) ->
        val mid = rules[pair] ?: return@flatMap listOf(pair to n)
        listOf("${pair[0]}$mid" to n, "$mid${pair[1]}" to n)
    }.groupingBy { it.first }.fold(0L) { acc, (_, n) -> acc + n }

/** Most common element count minus least common, after `steps` insertions. */
fun Polymer.spread(steps: Int): Long {
    val start = template.windowed(2).groupingBy { it }.eachCount().mapValues { it.value.toLong() }
    val pairs = generateSequence(start, ::step).elementAt(steps)
    // Every element except the template's last is the first letter of exactly one pair.
    val counts = pairs.entries.groupingBy { it.key[0] }.fold(0L) { acc, e -> acc + e.value }
        .toMutableMap().apply { merge(template.last(), 1L, Long::plus) }
    return counts.values.max() - counts.values.min()
}

fun solve(input: String): Any = parse(input).spread(10)

// Two entries summing to 2020: one pass, remembering numbers seen so far in a set.
package part1

const val TARGET = 2020

fun parse(input: String): List<Int> = input.lines().filter { it.isNotBlank() }.map { it.trim().toInt() }

/** Product of some a, b in nums with a + b == target, or null. */
fun pairProduct(nums: List<Int>, target: Int): Long? {
    val seen = HashSet<Int>()
    for (n in nums) {
        if (target - n in seen) return n.toLong() * (target - n)
        seen += n
    }
    return null
}

fun solve(input: String): Any = pairProduct(parse(input), TARGET) ?: error("no pair")

// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
fun main() {
    val input = System.`in`.readBytes().decodeToString()
    println(if (System.getenv("AOC_PART") == "2") part2.solve(input) else part1.solve(input))
}

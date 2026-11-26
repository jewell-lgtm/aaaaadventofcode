// humn is the unknown. Walk from root down the side that depends on humn, inverting
// each operation against the constant side's value.
package part2

import part1.Jobs
import part1.Num
import part1.Op
import part1.eval
import part1.parse

const val HUMAN = "humn"

fun Jobs.dependsOnHuman(name: String): Boolean = name == HUMAN || when (val job = getValue(name)) {
    is Num -> false
    is Op -> dependsOnHuman(job.left) || dependsOnHuman(job.right)
}

/** The value humn must shout so that monkey `name` yields `target`. */
tailrec fun Jobs.solveFor(name: String, target: Long): Long {
    if (name == HUMAN) return target
    val (left, op, right) = getValue(name) as Op
    return if (dependsOnHuman(left)) {
        val v = eval(right) // target = x op v
        solveFor(left, when (op) { '+' -> target - v; '-' -> target + v; '*' -> target / v; else -> target * v })
    } else {
        val v = eval(left) // target = v op x
        solveFor(right, when (op) { '+' -> target - v; '-' -> v - target; '*' -> target / v; else -> v / target })
    }
}

fun solve(input: String): Any {
    val jobs = parse(input)
    val (left, _, right) = jobs.getValue("root") as Op
    return if (jobs.dependsOnHuman(left)) jobs.solveFor(left, jobs.eval(right)) else jobs.solveFor(right, jobs.eval(left))
}

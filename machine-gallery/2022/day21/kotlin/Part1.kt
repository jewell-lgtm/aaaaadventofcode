// Jobs as a sealed interface (a number or an operation on two monkeys); evaluation is a
// recursive `when` that the compiler checks for exhaustiveness.
package part1

sealed interface Job
data class Num(val value: Long) : Job
data class Op(val left: String, val op: Char, val right: String) : Job

typealias Jobs = Map<String, Job>

fun parse(input: String): Jobs = input.lines().filter { it.isNotBlank() }.associate { line ->
    val (name, job) = line.split(": ")
    val parts = job.split(" ")
    name to if (parts.size == 1) Num(parts[0].toLong()) else Op(parts[0], parts[1][0], parts[2])
}

fun apply(op: Char, a: Long, b: Long) = when (op) {
    '+' -> a + b
    '-' -> a - b
    '*' -> a * b
    '/' -> a / b
    else -> error("op $op")
}

fun Jobs.eval(name: String): Long = when (val job = getValue(name)) {
    is Num -> job.value
    is Op -> apply(job.op, eval(job.left), eval(job.right))
}

fun solve(input: String): Any = parse(input).eval("root")

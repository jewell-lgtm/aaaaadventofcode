// Monkeys parsed block by block with destructured regex groups; the operation is a
// (Long) -> Long lambda. Simulation moves items between ArrayDeques.
package part1

class Monkey(
    val items: ArrayDeque<Long>,
    val operation: (Long) -> Long,
    val divisor: Long,
    private val ifTrue: Int,
    private val ifFalse: Int,
) {
    var inspected = 0L
    fun target(worry: Long) = if (worry % divisor == 0L) ifTrue else ifFalse
}

private val BLOCK = Regex(
    """Monkey \d+:\s+Starting items: ([\d, ]*)\s+Operation: new = old ([*+]) (\w+)\s+""" +
        """Test: divisible by (\d+)\s+If true: throw to monkey (\d+)\s+If false: throw to monkey (\d+)"""
)

private fun operation(op: String, operand: String): (Long) -> Long {
    val n = operand.toLongOrNull()
    return when (op) {
        "*" -> { old -> old * (n ?: old) }
        else -> { old -> old + (n ?: old) }
    }
}

fun parse(input: String): List<Monkey> = BLOCK.findAll(input).map { m ->
    val (items, op, operand, divisor, ifTrue, ifFalse) = m.destructured
    Monkey(
        ArrayDeque(items.split(", ").map(String::toLong)),
        operation(op, operand), divisor.toLong(), ifTrue.toInt(), ifFalse.toInt(),
    )
}.toList()

fun monkeyBusiness(monkeys: List<Monkey>, rounds: Int, relief: (Long) -> Long): Long {
    repeat(rounds) {
        for (m in monkeys) {
            while (m.items.isNotEmpty()) {
                val worry = relief(m.operation(m.items.removeFirst()))
                monkeys[m.target(worry)].items.addLast(worry)
                m.inspected++
            }
        }
    }
    return monkeys.map { it.inspected }.sortedDescending().take(2).reduce(Long::times)
}

fun solve(input: String): Any = monkeyBusiness(parse(input), 20) { it / 3 }

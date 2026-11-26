// Parse the drawing into ArrayDeques (one per column, top first) and the moves into
// a data class, then replay. A crane is just a function from (from, to, count) to effects.
package part1

data class Move(val count: Int, val from: Int, val to: Int)

class Ship(val stacks: List<ArrayDeque<Char>>, val moves: List<Move>) {
    fun tops(): String = stacks.joinToString("") { it.first().toString() }
}

fun parse(input: String): Ship {
    val (drawing, procedure) = input.split("\n\n", limit = 2)
    val rows = drawing.lines()
    val width = rows.last().trim().split(Regex("\\s+")).size
    val stacks = List(width) { i ->
        ArrayDeque(rows.dropLast(1).mapNotNull { row -> row.getOrNull(1 + 4 * i)?.takeIf(Char::isLetter) })
    }
    val moves = Regex("""move (\d+) from (\d+) to (\d+)""").findAll(procedure).map { m ->
        val (n, from, to) = m.destructured.toList().map(String::toInt)
        Move(n, from - 1, to - 1)
    }.toList()
    return Ship(stacks, moves)
}

fun operate(input: String, crane: (from: ArrayDeque<Char>, to: ArrayDeque<Char>, count: Int) -> Unit): String {
    val ship = parse(input)
    for ((count, from, to) in ship.moves) crane(ship.stacks[from], ship.stacks[to], count)
    return ship.tops()
}

fun solve(input: String): Any = operate(input) { from, to, count ->
    repeat(count) { to.addFirst(from.removeFirst()) }
}

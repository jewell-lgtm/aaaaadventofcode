// Each hand gets a sort key: its shape (group sizes, largest first) followed by
// its cards' strengths. Sorting by that key lexicographically ranks the hands.
package part1

data class Hand(val cards: String, val bid: Long)

fun parse(input: String) = input.lines().filter { it.isNotBlank() }.map {
    val (cards, bid) = it.split(" ")
    Hand(cards, bid.toLong())
}

/** Group sizes, largest first: [3, 2] is a full house, [1, 1, 1, 1, 1] high card. */
fun shape(cards: String): List<Int> = cards.groupingBy { it }.eachCount().values.sortedDescending()

/** Kotlin has no built-in ordering for lists, so compare element by element. */
val lexicographic = Comparator<List<Int>> { a, b ->
    a.zip(b).firstOrNull { (x, y) -> x != y }?.let { (x, y) -> x.compareTo(y) } ?: 0
}

fun winnings(hands: List<Hand>, shapeOf: (String) -> List<Int>, order: String): Long {
    // Different shapes differ before the card part starts; equal shapes have equal length.
    val strength = { h: Hand -> shapeOf(h.cards) + h.cards.map(order::indexOf) }
    return hands.sortedWith(compareBy(lexicographic, strength)).withIndex().sumOf { (i, h) -> (i + 1) * h.bid }
}

fun solve(input: String): Any = winnings(parse(input), ::shape, "23456789TJQKA")

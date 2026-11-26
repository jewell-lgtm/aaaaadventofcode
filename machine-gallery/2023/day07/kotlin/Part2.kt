// Jokers join the biggest group of real cards; J is weakest in tie-breaks.
package part2

import part1.parse
import part1.shape
import part1.winnings

fun jokerShape(cards: String): List<Int> {
    val jokers = cards.count { it == 'J' }
    val rest = shape(cards.replace("J", "")).ifEmpty { listOf(0) }
    return listOf(rest.first() + jokers) + rest.drop(1)
}

fun solve(input: String): Any = winnings(parse(input), ::jokerShape, "J23456789TQKA")

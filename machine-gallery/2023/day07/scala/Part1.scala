// Ordering by a key: (shape, card strengths). Scala's Ordering composes for tuples and
// Iterables (via Ordering.Implicits), so the sort is one `sortBy`.
import scala.math.Ordering.Implicits.seqOrdering

object Part1:
  case class Hand(cards: String, bid: Long)

  def parse(input: String): Seq[Hand] =
    input.linesIterator.filter(_.nonEmpty).map(_.split(" ")).map { case Array(c, b) => Hand(c, b.toLong) }.toSeq

  /** Group sizes, largest first: List(3, 2) is a full house. */
  def shape(cards: String): List[Int] = cards.groupMapReduce(identity)(_ => 1)(_ + _).values.toList.sorted.reverse

  def winnings(hands: Seq[Hand], shapeOf: String => List[Int], order: String): Long =
    hands
      .sortBy(h => (shapeOf(h.cards), h.cards.map(order.indexOf(_)).toList))
      .zipWithIndex
      .map((h, i) => h.bid * (i + 1))
      .sum

  def solve(input: String): Any = winnings(parse(input), shape, "23456789TJQKA")

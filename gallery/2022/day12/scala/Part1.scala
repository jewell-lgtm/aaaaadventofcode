// BFS backwards from E with a tail-recursive loop over an immutable Queue and a
// distance Map. Part 2 only swaps the goal predicate.
import scala.annotation.tailrec
import scala.collection.immutable.Queue

object Part1:
  type Pos = (Int, Int)

  class Hill(rows: Vector[String]):
    private def find(ch: Char): Pos = rows.indices.collectFirst { case r if rows(r).contains(ch) => (r, rows(r).indexOf(ch)) }.get
    val start: Pos = find('S')
    val end: Pos = find('E')

    def height(p: Pos): Option[Char] =
      rows.lift(p._1).flatMap(_.lift(p._2)).map {
        case 'S' => 'a'
        case 'E' => 'z'
        case c   => c
      }

    /** Fewest steps from any square satisfying `goal` up to E. */
    def stepsFromEnd(goal: Pos => Boolean): Int =
      @tailrec def go(queue: Queue[Pos], dist: Map[Pos, Int]): Int =
        val (cur @ (r, c), rest) = queue.dequeue
        if goal(cur) then dist(cur)
        else
          val next = for
            n <- List((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1))
            h <- height(n)
            if !dist.contains(n) && height(cur).get - h <= 1
          yield n
          go(rest.enqueueAll(next), dist ++ next.map(_ -> (dist(cur) + 1)))
      go(Queue(end), Map(end -> 0))

  def parse(input: String) = Hill(input.linesIterator.filter(_.nonEmpty).toVector)

  def solve(input: String): Any =
    val hill = parse(input)
    hill.stepsFromEnd(_ == hill.start)

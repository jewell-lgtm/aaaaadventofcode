// Dijkstra with scala.collection.mutable.PriorityQueue (a max-heap, so the ordering is
// reversed) and an Array of best distances; stale entries are skipped.
import scala.collection.mutable

object Part1:
  case class Cave(rows: Int, cols: Int, risk: (Int, Int) => Int)

  def parse(input: String): Cave =
    val grid = input.linesIterator.filter(_.nonEmpty).map(_.map(_.asDigit).toArray).toArray
    Cave(grid.length, grid(0).length, (r, c) => grid(r)(c))

  def lowestRisk(cave: Cave): Int =
    import cave.*
    val best = Array.fill(rows, cols)(Int.MaxValue)
    val queue = mutable.PriorityQueue((0, 0, 0))(using Ordering.by[(Int, Int, Int), Int](_._1).reverse)
    best(0)(0) = 0
    while queue.nonEmpty do
      val (d, r, c) = queue.dequeue()
      if r == rows - 1 && c == cols - 1 then return d
      if d == best(r)(c) then
        for (nr, nc) <- List((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1))
            if nr >= 0 && nr < rows && nc >= 0 && nc < cols
        do
          val nd = d + risk(nr, nc)
          if nd < best(nr)(nc) then
            best(nr)(nc) = nd
            queue.enqueue((nd, nr, nc))
    sys.error("unreachable")

  def solve(input: String): Any = lowestRisk(parse(input))

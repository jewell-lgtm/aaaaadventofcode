// Count arrangements by recursion on (remaining springs, remaining groups) with pattern
// matching on the head character; a mutable.HashMap memoises by (index, group index).
import scala.collection.mutable

object Part1:
  case class Row(springs: String, groups: Vector[Int]):
    def arrangements: Long =
      val memo = mutable.HashMap.empty[(Int, Int), Long]
      def count(i: Int, g: Int): Long = memo.getOrElseUpdate((i, g),
        springs.lift(i) match
          case None      => if g == groups.size then 1 else 0
          case Some('.') => count(i + 1, g)
          case Some('#') => placeGroup(i, g)
          case Some(_)   => count(i + 1, g) + placeGroup(i, g) // '?': either
      )
      // A group of groups(g) damaged springs starts at i, followed by a gap.
      def placeGroup(i: Int, g: Int): Long =
        groups.lift(g) match
          case Some(n) if i + n <= springs.length && !springs.slice(i, i + n).contains('.') && !springs.lift(i + n).contains('#') =>
            count(i + n + 1, g + 1)
          case _ => 0
      count(0, 0)

    def unfold(times: Int): Row = Row(Seq.fill(times)(springs).mkString("?"), Vector.fill(times)(groups).flatten)

  def parse(input: String): Seq[Row] =
    input.linesIterator.filter(_.nonEmpty).map(_.split(" ")).map { case Array(s, g) => Row(s, g.split(",").map(_.toInt).toVector) }.toSeq

  def solve(input: String): Any = parse(input).map(_.arrangements).sum

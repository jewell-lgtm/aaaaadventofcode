// Stacks are immutable Lists (head = top) in a Vector; each move is a pure update,
// so the whole procedure is a foldLeft. The crane is passed in as a function.
object Part1:
  case class Move(count: Int, from: Int, to: Int)
  type Stacks = Vector[List[Char]]

  private val MoveLine = """move (\d+) from (\d+) to (\d+)""".r

  def parse(input: String): (Stacks, List[Move]) =
    val Array(drawing, procedure) = input.split("\n\n", 2)
    val rows = drawing.linesIterator.toVector
    val width = rows.last.trim.split("\\s+").length
    val stacks = Vector.tabulate(width)(i => rows.init.flatMap(_.lift(1 + 4 * i)).filter(_.isLetter).toList)
    val moves = procedure.linesIterator.collect { case MoveLine(n, f, t) => Move(n.toInt, f.toInt - 1, t.toInt - 1) }.toList
    (stacks, moves)

  /** Apply all moves; `lift` turns the taken crates into the order they land in. */
  def operate(input: String)(lift: List[Char] => List[Char]): String =
    val (stacks, moves) = parse(input)
    val end = moves.foldLeft(stacks) { case (s, Move(n, from, to)) =>
      val (taken, rest) = s(from).splitAt(n)
      s.updated(from, rest).updated(to, lift(taken) ++ s(to))
    }
    end.map(_.head).mkString

  def solve(input: String): Any = operate(input)(_.reverse) // one at a time: order flips

// Monkeys parsed by matching each block's lines against regex extractors; the operation
// becomes a Long => Long. Items live in mutable queues during the simulation.
import scala.collection.mutable

object Part1:
  case class Monkey(start: List[Long], op: Long => Long, divisor: Long, ifTrue: Int, ifFalse: Int):
    def target(worry: Long): Int = if worry % divisor == 0 then ifTrue else ifFalse

  private val Items = """\s*Starting items: (.*)""".r
  private val Operation = """\s*Operation: new = old ([*+]) (\w+)""".r
  private val Last = """.*?(\d+)$""".r

  private def operation(op: String, operand: String): Long => Long = (op, operand.toLongOption) match
    case ("*", None)    => old => old * old
    case ("*", Some(n)) => _ * n
    case (_, None)      => old => old + old
    case (_, Some(n))   => _ + n

  def parse(input: String): Vector[Monkey] =
    input.split("\n\n").toVector.map(_.linesIterator.toList).map {
      case _ :: Items(items) :: Operation(op, x) :: Last(d) :: Last(t) :: Last(f) :: _ =>
        Monkey(items.split(", ").map(_.toLong).toList, operation(op, x), d.toLong, t.toInt, f.toInt)
      case block => sys.error(s"bad monkey: $block")
    }

  def monkeyBusiness(monkeys: Vector[Monkey], rounds: Int, relief: Long => Long): Long =
    val items = monkeys.map(m => mutable.Queue.from(m.start))
    val inspected = Array.fill(monkeys.size)(0L)
    for _ <- 1 to rounds; (m, i) <- monkeys.zipWithIndex do
      inspected(i) += items(i).size
      for old <- items(i).removeAll() do
        val worry = relief(m.op(old))
        items(m.target(worry)).enqueue(worry)
    inspected.sorted.takeRight(2).product

  def solve(input: String): Any = monkeyBusiness(parse(input), 20, _ / 3)

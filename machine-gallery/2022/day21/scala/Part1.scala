// Monkey jobs as a Scala 3 enum (an ADT); eval is a recursive match. Parsing uses
// string interpolator patterns: `case s"$a $op $b"`.
object Part1:
  enum Job:
    case Num(value: Long)
    case Op(left: String, op: Char, right: String)
  import Job.*

  type Jobs = Map[String, Job]

  def parse(input: String): Jobs = input.linesIterator.filter(_.nonEmpty).map {
    case s"$name: $a $op $b" => name -> Op(a, op.head, b)
    case s"$name: $n"        => name -> Num(n.toLong)
  }.toMap

  def apply(op: Char, a: Long, b: Long): Long = op match
    case '+' => a + b
    case '-' => a - b
    case '*' => a * b
    case '/' => a / b

  def eval(jobs: Jobs, name: String): Long = jobs(name) match
    case Num(v)       => v
    case Op(l, op, r) => apply(op, eval(jobs, l), eval(jobs, r))

  def solve(input: String): Any = eval(parse(input), "root")

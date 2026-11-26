// humn is the unknown. Walk from root down the side that depends on humn, inverting
// each operation against the constant side's value.
import scala.annotation.tailrec
import Part1.{Jobs, eval}
import Part1.Job.*

object Part2:
  val Human = "humn"

  def dependsOnHuman(jobs: Jobs, name: String): Boolean =
    name == Human || (jobs(name) match
      case Num(_)      => false
      case Op(l, _, r) => dependsOnHuman(jobs, l) || dependsOnHuman(jobs, r))

  /** The value humn must shout so that monkey `name` yields `target`. */
  @tailrec def solveFor(jobs: Jobs, name: String, target: Long): Long =
    if name == Human then target
    else jobs(name) match
      case Op(l, op, r) if dependsOnHuman(jobs, l) => // target = x op v
        val v = eval(jobs, r)
        solveFor(jobs, l, op match { case '+' => target - v; case '-' => target + v; case '*' => target / v; case _ => target * v })
      case Op(l, op, r) => // target = v op x
        val v = eval(jobs, l)
        solveFor(jobs, r, op match { case '+' => target - v; case '-' => v - target; case '*' => target / v; case _ => v / target })
      case Num(_) => sys.error(s"$name is constant")

  def solve(input: String): Any =
    val jobs = Part1.parse(input)
    jobs("root") match
      case Op(l, _, r) if dependsOnHuman(jobs, l) => solveFor(jobs, l, eval(jobs, r))
      case Op(l, _, r)                            => solveFor(jobs, r, eval(jobs, l))
      case Num(_)                                 => sys.error("root must be an operation")

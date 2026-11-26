// Count pairs instead of building the polymer: each rule AB -> C turns AB into AC + CB.
// `groupMapReduce` merges the counts each step; Iterator.iterate runs the steps.
object Part1:
  case class Polymer(template: String, rules: Map[String, Char])

  def parse(input: String): Polymer =
    val Array(template, rules) = input.trim.split("\n\n")
    Polymer(template.trim, rules.linesIterator.collect { case s"$pair -> $c" => pair -> c.head }.toMap)

  def step(rules: Map[String, Char])(pairs: Map[String, Long]): Map[String, Long] =
    pairs.toSeq
      .flatMap((pair, n) => rules.get(pair).fold(Seq(pair -> n))(c => Seq(s"${pair(0)}$c" -> n, s"$c${pair(1)}" -> n)))
      .groupMapReduce(_._1)(_._2)(_ + _)

  /** Most common element count minus least common after `steps` insertions. */
  def spread(p: Polymer, steps: Int): Long =
    val start = p.template.sliding(2).toSeq.groupMapReduce(identity)(_ => 1L)(_ + _)
    val pairs = Iterator.iterate(start)(step(p.rules)).drop(steps).next()
    // Each element except the template's last is the first letter of exactly one pair.
    val counts = (pairs.toSeq.map((pair, n) => pair(0) -> n) :+ (p.template.last -> 1L)).groupMapReduce(_._1)(_._2)(_ + _)
    counts.values.max - counts.values.min

  def solve(input: String): Any = spread(parse(input), 10)

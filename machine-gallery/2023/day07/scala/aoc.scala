// Harness helpers.
//   example: true when running an example (aoc test).
//   arg("size", 71): example-specific constant from examples.toml `args`, else the default.
package aoc

val example: Boolean = sys.env.get("AOC_EXAMPLE").contains("1")

private lazy val args: Map[String, ujson.Value] = ujson.read(sys.env.getOrElse("AOC_ARGS", "{}")).obj.toMap

/** Reads a value of the default's type: Int, Long, Double, Boolean or String. */
def arg[A](name: String, default: A): A =
  args.get(name).fold(default) { v =>
    (default match
      case _: Int     => v.num.toInt
      case _: Long    => v.num.toLong
      case _: Double  => v.num
      case _: Boolean => v.bool
      case _          => v.str
    ).asInstanceOf[A]
  }

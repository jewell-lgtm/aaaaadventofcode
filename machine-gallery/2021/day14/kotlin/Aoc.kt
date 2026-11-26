// Harness helpers.
//   example: true when running an example (aoc test).
//   arg("size", 71): example-specific constant from examples.toml `args`, else the default.
package aoc

val example: Boolean = System.getenv("AOC_EXAMPLE") == "1"

private val args: Map<String, String> =
    // Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS (no JSON in the stdlib).
    Regex(""""([^"]*)"\s*:\s*(?:"([^"]*)"|([^,}\s]+))""")
        .findAll(System.getenv("AOC_ARGS") ?: "{}")
        .associate { m -> m.groupValues[1] to m.groupValues[2].ifEmpty { m.groupValues[3] } }

fun arg(name: String, default: Int): Int = args[name]?.toInt() ?: default
fun arg(name: String, default: Long): Long = args[name]?.toLong() ?: default
fun arg(name: String, default: Boolean): Boolean = args[name]?.toBoolean() ?: default
fun arg(name: String, default: String): String = args[name] ?: default

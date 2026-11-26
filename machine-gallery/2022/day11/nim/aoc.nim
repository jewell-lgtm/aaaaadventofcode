## Harness helpers.
##   example         true when running an example (aoc test)
##   arg("size", 71) example-specific constant from examples.toml `args`, else the default
import std/[json, os]

let example* = getEnv("AOC_EXAMPLE") == "1"
let aocArgs = parseJson(getEnv("AOC_ARGS", "{}"))

proc arg*[T](name: string, default: T): T =
  if aocArgs.hasKey(name): aocArgs[name].to(T) else: default

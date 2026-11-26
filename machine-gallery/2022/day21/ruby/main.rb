# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
$LOAD_PATH.unshift(__dir__)
require(ENV["AOC_PART"] == "2" ? "part2" : "part1")
puts solve($stdin.read)

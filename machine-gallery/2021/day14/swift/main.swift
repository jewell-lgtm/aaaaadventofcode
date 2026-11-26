// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
// Each part is its own binary (main + Aoc + PartN), so both parts can define `solve`.
var input = ""
while let line = readLine(strippingNewline: false) { input += line }
print(solve(input))

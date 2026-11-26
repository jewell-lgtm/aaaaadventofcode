-- Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
package.path = "./?.lua;" .. package.path
local part = os.getenv("AOC_PART") == "2" and "part2" or "part1"
local solve = require(part)
print(tostring(solve(io.read("a"))))

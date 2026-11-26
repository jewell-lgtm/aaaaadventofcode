# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
import os
import sys

part = os.environ.get("AOC_PART", "1")
module = __import__("part2" if part == "2" else "part1")
print(module.solve(sys.stdin.read()))

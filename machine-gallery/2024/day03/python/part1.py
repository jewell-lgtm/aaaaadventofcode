# Mull It Over, part 1: re.findall returns the capture groups as tuples; sum their products.
# Python: findall + a generator expression is the whole program.
import re


def solve(input: str) -> int:
    return sum(int(a) * int(b) for a, b in re.findall(r"mul\((\d{1,3}),(\d{1,3})\)", input))

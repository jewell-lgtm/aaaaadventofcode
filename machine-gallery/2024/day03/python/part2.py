# Mull It Over, part 2: re.finditer over an alternation, matched with structural pattern matching.
# Python: match/case on the matched text keeps the on/off state machine flat.
import re

TOKEN = re.compile(r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")


def solve(input: str) -> int:
    enabled, total = True, 0
    for m in TOKEN.finditer(input):
        match m[0]:
            case "do()":
                enabled = True
            case "don't()":
                enabled = False
            case _ if enabled:
                total += int(m[1]) * int(m[2])
    return total

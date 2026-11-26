# Shared parser: transpose the drawing with zip(*rows) so every stack becomes one column string.
import re


def parse(input: str) -> tuple[list[list[str]], list[tuple[int, int, int]]]:
    drawing, procedure = input.rstrip("\n").split("\n\n")
    rows = drawing.split("\n")
    width = max(map(len, rows))
    columns = zip(*(row.ljust(width) for row in reversed(rows)))
    stacks = [list("".join(col[1:]).strip()) for col in columns if col[0].isdigit()]
    moves = [(n, f - 1, t - 1) for n, f, t in (map(int, m) for m in re.findall(r"(\d+)\D+(\d+)\D+(\d+)", procedure))]
    return stacks, moves


def tops(stacks: list[list[str]]) -> str:
    return "".join(s[-1] for s in stacks if s)

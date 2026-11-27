from aoc import arg, example


def solve(input: str) -> int | str:
    chars = [char for char in input.strip()]

    i = 0
    floor = 0
    for char in chars:
        i += 1
        floor += 1 if char == "(" else -1

        if floor < 0:
            return i

    raise ValueError("No floor found")

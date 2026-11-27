from aoc import arg, example


def solve(input: str) -> int | str:
    chars = [char for char in input.strip()]

    floor = 0
    for char in chars:
        if floor < 0:
            return floor
        floor += 1 if char == "(" else -1

    return floor

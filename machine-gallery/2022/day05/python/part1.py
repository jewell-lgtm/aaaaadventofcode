# Supply Stacks, part 1: lists as stacks, crates moved one at a time (so the slice is reversed).
# Python: slice assignment and del make the move a two-liner.
from stacks import parse, tops


def solve(input: str) -> str:
    stacks, moves = parse(input)
    for n, src, dst in moves:
        stacks[dst] += reversed(stacks[src][-n:])
        del stacks[src][-n:]
    return tops(stacks)

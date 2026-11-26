# Supply Stacks, part 2: same simulation, but the slice keeps its order.
# Python: identical to part 1 without reversed().
from stacks import parse, tops


def solve(input: str) -> str:
    stacks, moves = parse(input)
    for n, src, dst in moves:
        stacks[dst] += stacks[src][-n:]
        del stacks[src][-n:]
    return tops(stacks)

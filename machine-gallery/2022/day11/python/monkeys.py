# Shared: a dataclass per monkey, parsed with regex; simulation parametrised by the relief step.
import math
import operator
import re
from dataclasses import dataclass
from typing import Callable


@dataclass
class Monkey:
    items: list[int]
    op: Callable[[int], int]
    divisor: int
    if_true: int
    if_false: int
    inspected: int = 0


def parse_monkey(block: str) -> Monkey:
    lines = block.splitlines()
    nums = lambda line: [int(n) for n in re.findall(r"\d+", line)]
    sym, rhs = re.search(r"old (.) (\w+)", lines[2]).groups()
    apply = {"*": operator.mul, "+": operator.add}[sym]
    return Monkey(
        items=nums(lines[1]),
        op=lambda old: apply(old, old if rhs == "old" else int(rhs)),
        divisor=nums(lines[3])[0],
        if_true=nums(lines[4])[0],
        if_false=nums(lines[5])[0],
    )


def monkey_business(input: str, rounds: int, relieve: Callable[[int], int]) -> int:
    monkeys = [parse_monkey(block) for block in input.strip().split("\n\n")]
    for _ in range(rounds):
        for m in monkeys:
            for item in m.items:
                worry = relieve(m.op(item))
                monkeys[m.if_true if worry % m.divisor == 0 else m.if_false].items.append(worry)
            m.inspected += len(m.items)
            m.items = []
    a, b = sorted(m.inspected for m in monkeys)[-2:]
    return a * b


def divisor_product(input: str) -> int:
    return math.prod(parse_monkey(b).divisor for b in input.strip().split("\n\n"))

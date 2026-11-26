# Shared: parse into {name: int | (left, op, right)}; evaluate and invert with match statements.
from fractions import Fraction


def parse(input: str) -> dict:
    tree = {}
    for line in input.splitlines():
        name, job = line.split(": ")
        parts = job.split()
        tree[name] = int(job) if len(parts) == 1 else tuple(parts)
    return tree


def evaluate(tree: dict, name: str) -> Fraction:
    match tree[name]:
        case int(n):
            return Fraction(n)
        case (left, op, right):
            a, b = evaluate(tree, left), evaluate(tree, right)
            match op:
                case "+": return a + b
                case "-": return a - b
                case "*": return a * b
                case "/": return a / b


def depends_on(tree: dict, name: str, target: str = "humn") -> bool:
    match tree[name]:
        case (left, _, right):
            return name == target or depends_on(tree, left, target) or depends_on(tree, right, target)
        case _:
            return name == target

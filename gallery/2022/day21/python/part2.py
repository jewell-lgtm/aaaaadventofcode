# Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
# inverting each operation against the value of the other (known) branch.
from fractions import Fraction

from monkeys import depends_on, evaluate, parse


def solve_for(tree: dict, name: str, target: Fraction) -> Fraction:
    if name == "humn":
        return target
    left, op, right = tree[name]
    if depends_on(tree, left):
        known = evaluate(tree, right)
        inverse = {"+": target - known, "-": target + known, "*": target / known, "/": target * known}
        return solve_for(tree, left, inverse[op])
    known = evaluate(tree, left)
    inverse = {"+": target - known, "-": known - target, "*": target / known, "/": known / target}
    return solve_for(tree, right, inverse[op])


def solve(input: str) -> int:
    tree = parse(input)
    left, _, right = tree["root"]
    tree["root"] = (left, "-", right)
    return int(solve_for(tree, "root", Fraction(0)))

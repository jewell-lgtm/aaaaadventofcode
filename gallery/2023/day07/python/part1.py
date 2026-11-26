# Camel Cards, part 1: no comparator needed: a key of ([3, 1, 1], [ranks...]) sorts correctly.
# Python: Counter for the hand type, list comparison for the tiebreak.
from cards import winnings


def solve(input: str) -> int:
    return winnings(input, order="23456789TJQKA")

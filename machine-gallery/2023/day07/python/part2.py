# Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
# Python: Counter.pop removes the jokers before adding them to the biggest group.
from cards import winnings


def solve(input: str) -> int:
    return winnings(input, order="J23456789TQKA", jokers=True)

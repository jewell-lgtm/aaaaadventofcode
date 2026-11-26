# Shared: sort hands by a tuple key (group sizes, card ranks); Python compares tuples natively.
from collections import Counter


def hand_key(hand: str, order: str, jokers: bool) -> tuple:
    counts = Counter(hand)
    wild = counts.pop("J", 0) if jokers else 0
    groups = sorted(counts.values(), reverse=True) or [0]
    groups[0] += wild
    return groups, [order.index(c) for c in hand]


def winnings(input: str, order: str, jokers: bool = False) -> int:
    hands = [line.split() for line in input.splitlines()]
    ranked = sorted(hands, key=lambda h: hand_key(h[0], order, jokers))
    return sum(rank * int(bid) for rank, (_, bid) in enumerate(ranked, start=1))

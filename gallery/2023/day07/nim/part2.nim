## Day 7, part 2 — same ranking, different `Rules`: J moves to the bottom
## of the card order and counts toward the largest group.
import part1

const jokerRules = Rules(order: "J23456789TQKA", jokers: true)

proc solve*(input: string): int =
  parseHands(input).totalWinnings(jokerRules)

## Day 7: Camel Cards — classify each hand from its `CountTable` into an enum,
## then rank by a single integer strength (type, then cards in base 13).
## A `Rules` object carries card order and joker handling so part 2 is data.
import std/[strutils, tables, algorithm]

type
  HandType = enum
    highCard, onePair, twoPair, threeKind, fullHouse, fourKind, fiveKind
  Hand* = object
    cards: string
    bid: int
  Rules* = object
    order*: string
    jokers*: bool

const standard* = Rules(order: "23456789TJQKA", jokers: false)

func parseHands*(input: string): seq[Hand] =
  for line in input.strip.splitLines:
    let parts = line.splitWhitespace
    result.add Hand(cards: parts[0], bid: parts[1].parseInt)

func classify(cards: string, jokers: bool): HandType =
  var counts = cards.toCountTable
  var wild = 0
  if jokers:
    wild = counts.getOrDefault('J')
    counts.del 'J'
  var sizes = @[0]                       # keeps JJJJJ well-defined
  for n in counts.values: sizes.add n
  sizes.sort(Descending)
  sizes[0] += wild                       # jokers always join the biggest group
  case sizes[0]
  of 5: fiveKind
  of 4: fourKind
  of 3: (if sizes[1] == 2: fullHouse else: threeKind)
  of 2: (if sizes[1] == 2: twoPair else: onePair)
  else: highCard

func strength(hand: Hand, rules: Rules): int =
  result = ord(classify(hand.cards, rules.jokers))
  for card in hand.cards:
    result = result * 13 + rules.order.find(card)

func totalWinnings*(hands: seq[Hand], rules: Rules): int =
  for rank, hand in hands.sortedByIt(it.strength(rules)):
    result += (rank + 1) * hand.bid

proc solve*(input: string): int =
  parseHands(input).totalWinnings(standard)

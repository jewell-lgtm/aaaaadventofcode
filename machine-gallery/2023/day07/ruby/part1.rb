# Camel Cards, part 1: tally the cards for the hand type, then tiebreak on card order.
# Ruby: tally + sort_by with an array key, no explicit comparator.
require "aoc"
require "cards"

def solve(input) = Cards.winnings(input, order: "23456789TJQKA")

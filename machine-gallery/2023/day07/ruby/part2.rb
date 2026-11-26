# Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
# Ruby: Hash#delete returns the joker count while removing it.
require "aoc"
require "cards"

def solve(input) = Cards.winnings(input, order: "J23456789TQKA", jokers: true)

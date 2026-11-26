# Chiton, part 1: Dijkstra from top-left to bottom-right.
# Ruby has no stdlib heap; with small integer weights a Hash of buckets is simpler anyway.
require "aoc"
require "chiton"

def solve(input) = Chiton.lowest_risk(input, 1)

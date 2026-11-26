# Hot Springs, part 1: count arrangements per row by branching on each '?'.
# Ruby: Hash.new with a default block is a self-filling memo table.
require "aoc"
require "springs"

def solve(input) = Springs.total(input, 1)

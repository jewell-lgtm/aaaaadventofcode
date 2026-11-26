# Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
# Ruby: Array#* repeats the groups; Integer grows to bignum if ever needed.
require "aoc"
require "springs"

def solve(input) = Springs.total(input, 5)

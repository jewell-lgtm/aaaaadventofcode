# Supply Stacks, part 2: the CrateMover 9001 moves the slice in one go, order kept.
# Ruby: part 1 without the reverse.
require "aoc"
require "stacks"

def solve(input)
  stacks, moves = Stacks.parse(input)
  moves.each { |m| stacks[m.to].concat(stacks[m.from].pop(m.count)) }
  Stacks.tops(stacks)
end

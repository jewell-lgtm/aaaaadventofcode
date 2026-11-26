# Supply Stacks, part 1: arrays as stacks, crates moved one at a time.
# Ruby: Array#pop(n) and concat; reverse models moving crates singly.
require "aoc"
require "stacks"

def solve(input)
  stacks, moves = Stacks.parse(input)
  moves.each { |m| stacks[m.to].concat(stacks[m.from].pop(m.count).reverse) }
  Stacks.tops(stacks)
end

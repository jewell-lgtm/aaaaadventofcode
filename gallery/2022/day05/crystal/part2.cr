# CrateMover 9001: Array#pop(n) lifts the top n crates in their original
# order, and concat drops them on the target stack in one go.
module Part2
  def self.solve(input : String)
    stacks, moves = Part1.parse(input)
    moves.each do |move|
      stacks[move.to].concat(stacks[move.from].pop(move.count))
    end
    Part1.tops(stacks)
  end
end

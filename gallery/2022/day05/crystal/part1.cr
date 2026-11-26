# Stacks are plain Arrays (push/pop at the end); the drawing is read
# bottom-up by fixed column offsets, moves become a `record`.
# Part 2 reuses `parse` and only swaps the crane's move rule.
module Part1
  record Move, count : Int32, from : Int32, to : Int32

  def self.solve(input : String)
    stacks, moves = parse(input)
    moves.each do |move|
      move.count.times { stacks[move.to] << stacks[move.from].pop }
    end
    tops(stacks)
  end

  def self.parse(input : String) : {Array(Array(Char)), Array(Move)}
    drawing, procedure = input.split("\n\n", 2)
    rows = drawing.lines
    stacks = Array.new(rows.pop.split.size) { [] of Char }
    rows.reverse_each do |row|
      stacks.each_with_index do |stack, i|
        crate = row[1 + 4 * i]?
        stack << crate if crate && crate.letter?
      end
    end
    {stacks, procedure.lines.reject(&.blank?).map { |line| parse_move(line) }}
  end

  def self.parse_move(line : String) : Move
    count, from, to = line.scan(/\d+/).map(&.[0].to_i)
    Move.new(count, from - 1, to - 1)
  end

  def self.tops(stacks : Array(Array(Char))) : String
    stacks.compact_map(&.last?).join
  end
end

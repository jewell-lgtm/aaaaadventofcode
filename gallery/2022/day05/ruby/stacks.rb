# Shared parser: pad the drawing rows, transpose the characters, keep columns ending in a digit.
module Stacks
  Move = Struct.new(:count, :from, :to)

  def self.parse(input)
    drawing, procedure = input.split("\n\n")
    rows = drawing.lines(chomp: true)
    width = rows.map(&:size).max
    stacks = rows.map { _1.ljust(width).chars }.transpose
                 .select { _1.last =~ /\d/ }
                 .map { |col| col[0...-1].reverse.reject { _1 == " " } }
    moves = procedure.scan(/\d+/).map(&:to_i).each_slice(3).map { |n, f, t| Move.new(n, f - 1, t - 1) }
    [stacks, moves]
  end

  def self.tops(stacks) = stacks.map(&:last).join
end

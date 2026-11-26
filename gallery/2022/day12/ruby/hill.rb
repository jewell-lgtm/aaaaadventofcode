# Shared: grid as a Hash {[r, c] => height}, BFS one frontier layer at a time.
require "set"

module Hill
  def self.parse(input)
    grid = {}
    input.lines(chomp: true).each_with_index do |row, r|
      row.each_char.with_index { |ch, c| grid[[r, c]] = ch }
    end
    grid
  end

  def self.height(ch) = { "S" => "a", "E" => "z" }.fetch(ch, ch).ord

  def self.shortest_path(input, start_chars)
    grid = parse(input)
    frontier = grid.select { |_, ch| start_chars.include?(ch) }.keys
    seen = frontier.to_set
    0.step do |steps|
      raise "no path" if frontier.empty?
      return steps if frontier.any? { grid[_1] == "E" }

      frontier = frontier.flat_map do |(r, c)|
        [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].select do |q|
          grid.key?(q) && height(grid[q]) - height(grid[[r, c]]) <= 1 && seen.add?(q)
        end
      end
    end
  end
end

# Breadth-first search with a Deque, run *downhill* from E so both parts
# share one search and differ only in the goal block passed to `descend`.
# Positions are tuples; the visited map doubles as the distance table.
module Part1
  alias Pos = {Int32, Int32}

  struct Heightmap
    @grid : Array(Array(Char))

    def initialize(input : String)
      @grid = input.lines.reject(&.empty?).map(&.chars)
    end

    def find(char : Char) : Pos
      @grid.each_with_index do |row, r|
        c = row.index(char)
        return {r, c} if c
      end
      raise "no #{char} on the map"
    end

    def square(pos : Pos) : Char
      @grid[pos[0]][pos[1]]
    end

    def height(pos : Pos) : Int32
      case square(pos)
      when 'S' then 'a'.ord
      when 'E' then 'z'.ord
      else          square(pos).ord
      end
    end

    def neighbours(pos : Pos) : Array(Pos)
      r, c = pos
      [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}].select do |(nr, nc)|
        nr.in?(0...@grid.size) && nc.in?(0...@grid[nr].size)
      end
    end

    # Fewest steps from E back to the first square satisfying the block,
    # i.e. the fewest steps from that square up to E.
    def descend(& : Pos -> Bool) : Int32
      start = find('E')
      steps = {start => 0}
      queue = Deque{start}
      while pos = queue.shift?
        return steps[pos] if yield pos
        neighbours(pos).each do |nxt|
          next if steps.has_key?(nxt) || height(nxt) < height(pos) - 1
          steps[nxt] = steps[pos] + 1
          queue << nxt
        end
      end
      raise "no route"
    end
  end

  def self.solve(input : String)
    map = Heightmap.new(input)
    start = map.find('S')
    map.descend { |pos| pos == start }
  end
end

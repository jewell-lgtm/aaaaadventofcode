# Dijkstra without a heap: edge weights are 1..9, so a bucket queue (Dial's
# algorithm) keyed by total risk is enough. A Hash with a default block
# hands out empty buckets on demand. The Cave struct knows how to tile itself.
module Part1
  alias Pos = {Int32, Int32}

  struct Cave
    getter rows : Int32
    getter cols : Int32
    @risks : Array(Array(Int32))

    def initialize(input : String, @tiles = 1)
      @risks = input.lines.reject(&.empty?).map(&.chars.map(&.to_i))
      @rows = @risks.size * @tiles
      @cols = @risks[0].size * @tiles
    end

    # Risk wraps 9 -> 1 each time the map repeats right or down.
    def risk(pos : Pos) : Int32
      r, c = pos
      h, w = @risks.size, @risks[0].size
      (@risks[r % h][c % w] - 1 + r // h + c // w) % 9 + 1
    end

    def neighbours(pos : Pos) : Array(Pos)
      r, c = pos
      [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}].select do |(nr, nc)|
        nr.in?(0...rows) && nc.in?(0...cols)
      end
    end

    def lowest_total_risk : Int32
      start, goal = {0, 0}, {rows - 1, cols - 1}
      best = {start => 0}
      buckets = Hash(Int32, Array(Pos)).new { |h, k| h[k] = [] of Pos }
      buckets[0] << start
      total = 0
      until buckets.empty?
        buckets.delete(total).try &.each do |pos|
          next if best[pos] < total # stale entry, already improved
          return total if pos == goal
          neighbours(pos).each do |nxt|
            candidate = total + risk(nxt)
            next if candidate >= best.fetch(nxt, Int32::MAX)
            best[nxt] = candidate
            buckets[candidate] << nxt
          end
        end
        total += 1
      end
      raise "goal unreachable"
    end
  end

  def self.solve(input : String)
    Cave.new(input).lowest_total_risk
  end
end

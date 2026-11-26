# Same downhill BFS from E; the first square at elevation 'a' it reaches is
# by construction the best trailhead.
module Part2
  def self.solve(input : String)
    map = Part1::Heightmap.new(input)
    map.descend { |pos| map.height(pos) == 'a'.ord }
  end
end

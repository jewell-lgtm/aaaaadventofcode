# The full map is the input tiled 5x5; Cave computes tiled risks on the fly,
# so the search itself is unchanged.
module Part2
  def self.solve(input : String)
    Part1::Cave.new(input, tiles: 5).lowest_total_risk
  end
end

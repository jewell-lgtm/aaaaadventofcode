# 40 steps would make a polymer of ~20 trillion elements, but the pair
# counts stay tiny, so it is the same function with a bigger number.
module Part2
  def self.solve(input : String)
    Part1.polymerise(input, 40)
  end
end

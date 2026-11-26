# Unfold each record five times (springs joined by '?', groups repeated);
# the memoised count from part 1 keeps this linear-ish per row.
module Part2
  def self.solve(input : String)
    Part1.records(input).sum do |springs, groups|
      Part1::Arrangements.new(([springs] * 5).join('?'), groups * 5).count
    end
  end
end

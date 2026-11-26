# Regex scan: String#scan yields MatchData, so the capture groups feed
# straight into an Enumerable#sum block.
module Part1
  MUL = /mul\((\d{1,3}),(\d{1,3})\)/

  def self.solve(input : String)
    input.scan(MUL).sum { |m| m[1].to_i64 * m[2].to_i64 }
  end
end

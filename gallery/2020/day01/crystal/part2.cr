# Same shape as part 1 with triples: ~1.3M combinations for 200 entries is
# well within budget for compiled Crystal, so no cleverness needed.
module Part2
  def self.solve(input : String)
    expenses = input.split.map(&.to_i64)
    expenses.each_combination(3).find! { |triple| triple.sum == 2020 }.product
  end
end

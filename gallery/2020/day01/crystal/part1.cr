# Enumerable#each_combination enumerates the pairs; find! stops at the first
# one that sums to 2020 (and raises if there is none).
module Part1
  def self.solve(input : String)
    expenses = input.split.map(&.to_i64)
    expenses.each_combination(2).find! { |pair| pair.sum == 2020 }.product
  end
end

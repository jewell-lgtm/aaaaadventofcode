# J becomes a joker: it moves to the front of the rank order and is folded
# into the biggest group when classifying the hand.
module Part2
  def self.solve(input : String)
    Part1.winnings(input, order: "J23456789TQKA", jokers: true)
  end
end

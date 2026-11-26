# Shared: sort_by a [group sizes, card ranks] key; Ruby compares arrays element-wise.
module Cards
  def self.key(hand, order, jokers)
    counts = hand.chars.tally
    wild = jokers ? counts.delete("J").to_i : 0
    groups = counts.values.sort.reverse.then { _1.empty? ? [0] : _1 }
    groups[0] += wild
    [groups, hand.chars.map { order.index(_1) }]
  end

  def self.winnings(input, order:, jokers: false)
    input.lines.map(&:split)
         .sort_by { |hand, _| key(hand, order, jokers) }
         .each.with_index(1)
         .sum { |(_, bid), rank| bid.to_i * rank }
  end
end

# Hands sort by a composite key: [type, card ranks...]. Arrays compare
# lexicographically, so sort_by does all the tie-breaking. The type comes
# from the sorted card tally, matched with a `case` on array literals.
module Part1
  record Hand, cards : String, bid : Int64

  def self.solve(input : String)
    winnings(input, order: "23456789TJQKA", jokers: false)
  end

  def self.winnings(input : String, order : String, jokers : Bool) : Int64
    hands = input.lines.reject(&.blank?).map do |line|
      cards, bid = line.split
      Hand.new(cards, bid.to_i64)
    end
    hands
      .sort_by { |hand| [kind(hand.cards, jokers)] + hand.cards.chars.map { |c| order.index!(c) } }
      .each_with_index(1)
      .sum { |hand, rank| hand.bid * rank }
  end

  # Jokers join whichever group is already largest; that is always best.
  def self.kind(cards : String, jokers : Bool) : Int32
    tally = cards.chars.tally
    wild = jokers ? tally.delete('J') || 0 : 0
    counts = tally.values.sort.reverse
    counts.empty? ? (counts << wild) : (counts[0] += wild)
    case counts
    when [5]          then 6
    when [4, 1]       then 5
    when [3, 2]       then 4
    when [3, 1, 1]    then 3
    when [2, 2, 1]    then 2
    when [2, 1, 1, 1] then 1
    else                   0
    end
  end
end

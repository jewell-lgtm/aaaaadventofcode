# Shared: a Struct per monkey, parsed from each paragraph; the relief step is a block.
module Monkeys
  Monkey = Struct.new(:items, :op, :divisor, :targets, :inspected)

  def self.parse(input)
    input.split("\n\n").map do |block|
      lines = block.lines
      nums = ->(line) { line.scan(/\d+/).map(&:to_i) }
      sym, rhs = lines[2].match(/old (.) (\w+)/).captures
      op = ->(old) { old.public_send(sym, rhs == "old" ? old : rhs.to_i) }
      Monkey.new(nums[lines[1]], op, nums[lines[3]][0], [nums[lines[4]][0], nums[lines[5]][0]], 0)
    end
  end

  def self.business(monkeys, rounds, &relieve)
    rounds.times do
      monkeys.each do |m|
        m.items.each do |item|
          worry = relieve.(m.op.(item))
          monkeys[m.targets[(worry % m.divisor).zero? ? 0 : 1]].items << worry
        end
        m.inspected += m.items.size
        m.items = []
      end
    end
    monkeys.map(&:inspected).max(2).inject(:*)
  end
end

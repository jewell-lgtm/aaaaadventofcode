# Each monkey is a small class with a Deque of worry levels; its operation
# is a `record` whose operand is `Int64?` (nil meaning "old"). `simulate`
# takes the relief rule as a block, which is all part 2 changes.
module Part1
  record Operation, op : Char, operand : Int64? do
    def apply(old : Int64) : Int64
      rhs = operand || old
      op == '*' ? old * rhs : old + rhs
    end
  end

  class Monkey
    getter items : Deque(Int64)
    getter divisor : Int64
    getter inspected = 0_i64

    def initialize(@items, @operation : Operation, @divisor, @if_true : Int32, @if_false : Int32)
    end

    def self.parse(block : String) : Monkey
      lines = block.lines.map(&.strip)
      items = Deque.new(lines[1].scan(/\d+/).map(&.[0].to_i64))
      op, operand = lines[2].split.last(2)
      divisor, if_true, if_false = lines[3..5].map(&.split.last.to_i)
      new(items, Operation.new(op[0], operand.to_i64?), divisor.to_i64, if_true, if_false)
    end

    # Inspect and throw everything held: returns {target monkey, worry} pairs.
    def turn(& : Int64 -> Int64) : Array({Int32, Int64})
      throws = @items.map do |item|
        worry = yield @operation.apply(item)
        {worry % divisor == 0 ? @if_true : @if_false, worry}
      end
      @inspected += @items.size
      @items.clear
      throws
    end
  end

  def self.parse(input : String) : Array(Monkey)
    input.split("\n\n").reject(&.blank?).map { |block| Monkey.parse(block) }
  end

  def self.monkey_business(monkeys : Array(Monkey), rounds : Int32, & : Int64 -> Int64) : Int64
    rounds.times do
      monkeys.each do |monkey|
        monkey.turn { |worry| yield worry }.each { |target, worry| monkeys[target].items << worry }
      end
    end
    monkeys.map(&.inspected).sort.last(2).product
  end

  def self.solve(input : String)
    monkey_business(parse(input), 20) { |worry| worry // 3 }
  end
end

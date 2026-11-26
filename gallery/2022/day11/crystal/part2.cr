# No more relief, so worries explode. Every test is "divisible by p", so
# reducing modulo the product of all divisors keeps every test's answer.
module Part2
  def self.solve(input : String)
    monkeys = Part1.parse(input)
    modulus = monkeys.product(&.divisor)
    Part1.monkey_business(monkeys, 10_000) { |worry| worry % modulus }
  end
end

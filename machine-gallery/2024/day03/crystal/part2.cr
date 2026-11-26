# One alternation regex for all three instructions, then a single pass with
# a case on the matched text toggling an `enabled` flag.
module Part2
  INSTRUCTION = /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/

  def self.solve(input : String)
    enabled = true
    input.scan(INSTRUCTION).sum do |m|
      case m[0]
      when "do()"    then enabled = true
      when "don't()" then enabled = false
      else                next m[1].to_i64 * m[2].to_i64 if enabled
      end
      0i64
    end
  end
end

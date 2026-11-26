# Never build the polymer: track how many times each adjacent pair occurs in
# a Hash with default 0. Each step splits a pair AB (rule AB -> C) into AC
# and CB. Element counts come from each pair's first char plus the last one.
module Part1
  alias Pair = {Char, Char}

  def self.polymerise(input : String, steps : Int32) : Int64
    template, rules_text = input.split("\n\n", 2)
    template = template.strip
    rules = rules_text.lines.reject(&.blank?).to_h do |line|
      pair, insert = line.split(" -> ")
      { {pair[0], pair[1]}, insert[0] }
    end

    pairs = Hash(Pair, Int64).new(0_i64)
    template.chars.each_cons_pair { |a, b| pairs[{a, b}] += 1 }

    steps.times { pairs = step(pairs, rules) }

    elements = Hash(Char, Int64).new(0_i64)
    pairs.each { |(a, _), n| elements[a] += n }
    elements[template[-1]] += 1
    elements.values.max - elements.values.min
  end

  def self.step(pairs : Hash(Pair, Int64), rules : Hash(Pair, Char)) : Hash(Pair, Int64)
    pairs.each_with_object(Hash(Pair, Int64).new(0_i64)) do |(pair, n), next_pairs|
      if insert = rules[pair]?
        next_pairs[{pair[0], insert}] += n
        next_pairs[{insert, pair[1]}] += n
      else
        next_pairs[pair] += n
      end
    end
  end

  def self.solve(input : String)
    polymerise(input, 10)
  end
end

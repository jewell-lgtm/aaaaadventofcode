# Shared: a Hash of pair counts; each rule AB -> C turns every AB into AC + CB.
module Polymer
  def self.spread(input, steps)
    template, rules_block = input.split("\n\n")
    rules = rules_block.lines(chomp: true).to_h { _1.split(" -> ") }
    pairs = template.chars.each_cons(2).map(&:join).tally

    steps.times do
      pairs = pairs.each_with_object(Hash.new(0)) do |(pair, n), nxt|
        if (c = rules[pair])
          nxt[pair[0] + c] += n
          nxt[c + pair[1]] += n
        else
          nxt[pair] += n
        end
      end
    end

    elements = Hash.new(0).merge(template[-1] => 1)
    pairs.each { |pair, n| elements[pair[0]] += n }
    elements.values.minmax.then { |least, most| most - least }
  end
end

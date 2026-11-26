# Mull It Over, part 2: scan an alternation in order, toggling with case/in on each token.
# Ruby: one capture group per token kind; sum with a block that also flips the flag.
require "aoc"

TOKEN = /mul\((\d{1,3}),(\d{1,3})\)|(do)\(\)|(don't)\(\)/

def solve(input)
  enabled = true
  input.scan(TOKEN).sum do |a, b, on, off|
    if on then enabled = true; 0
    elsif off then enabled = false; 0
    elsif enabled then a.to_i * b.to_i
    else 0
    end
  end
end

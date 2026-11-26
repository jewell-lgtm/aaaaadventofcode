# Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
# inverting each operation against the value of the other (known) branch.
require "aoc"
require "monkeys"

def solve_for(tree, name, target)
  return target if name == "humn"

  left, op, right = tree[name]
  if MonkeyMath.depends_on?(tree, left)
    known = MonkeyMath.evaluate(tree, right)
    solve_for(tree, left, { "+" => target - known, "-" => target + known, "*" => target / known, "/" => target * known }[op])
  else
    known = MonkeyMath.evaluate(tree, left)
    solve_for(tree, right, { "+" => target - known, "-" => known - target, "*" => target / known, "/" => known / target }[op])
  end
end

def solve(input)
  tree = MonkeyMath.parse(input)
  tree["root"][1] = "-"
  solve_for(tree, "root", 0r).to_i
end

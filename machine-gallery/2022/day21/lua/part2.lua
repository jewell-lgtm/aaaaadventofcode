-- Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
-- inverting each operation against the value of the other (known) branch.
local monkeys = require("monkeys")
local ops = monkeys.ops

local inverse_left = { ["+"] = "-", ["-"] = "+", ["*"] = "/", ["/"] = "*" }

local function solve_for(tree, name, target)
  if name == "humn" then return target end
  local left, op, right = table.unpack(tree[name])
  if monkeys.depends_on(tree, left) then
    return solve_for(tree, left, ops[inverse_left[op]](target, monkeys.evaluate(tree, right)))
  end
  local known = monkeys.evaluate(tree, left)
  if op == "-" or op == "/" then return solve_for(tree, right, ops[op](known, target)) end
  return solve_for(tree, right, ops[inverse_left[op]](target, known))
end

return function(input)
  local tree = monkeys.parse(input)
  tree.root[2] = "-"
  return monkeys.whole(solve_for(tree, "root", 0))
end

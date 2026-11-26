-- Monkey Math, part 1: recursively evaluate the expression tree from root.
-- Lua: type(job) distinguishes number leaves from operator tables.
local monkeys = require("monkeys")

return function(input)
  return monkeys.whole(monkeys.evaluate(monkeys.parse(input), "root"))
end

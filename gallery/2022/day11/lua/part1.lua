-- Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
-- Lua: block:match with patterns pulls each field out of the paragraph.
local monkeys = require("monkeys")

return function(input)
  return monkeys.business(monkeys.parse(input), 20, function(w) return w // 3 end)
end

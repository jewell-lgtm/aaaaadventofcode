-- Supply Stacks, part 2: the CrateMover 9001 keeps the slice's order.
-- Lua: same mover, keep_order = true.
local stacks = require("stacks")

return function(input) return stacks.run(input, true) end

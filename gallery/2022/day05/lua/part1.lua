-- Supply Stacks, part 1: array tables as stacks; crates move one at a time (reversed).
-- Lua: everything is an array table indexed from 1; the shared module holds parse + move.
local stacks = require("stacks")

return function(input) return stacks.run(input, false) end

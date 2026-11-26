-- Hot Springs, part 1: count arrangements per row by branching on each '?'.
-- Lua: a local recursive function closing over a memo table.
local springs = require("springs")

return function(input) return springs.total(input, 1) end

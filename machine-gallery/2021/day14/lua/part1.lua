-- Extended Polymerization, part 1: 10 steps, then most common minus least common element.
-- Lua: string tables as counters; gmatch reads all the rules in one loop.
local polymer = require("polymer")

return function(input) return polymer.spread(input, 10) end

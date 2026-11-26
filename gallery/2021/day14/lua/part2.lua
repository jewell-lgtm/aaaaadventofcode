-- Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
-- Lua 5.4: integer counts are 64-bit, so ~1e13 is exact.
local polymer = require("polymer")

return function(input) return polymer.spread(input, 40) end

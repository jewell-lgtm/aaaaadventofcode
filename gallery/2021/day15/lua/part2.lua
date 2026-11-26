-- Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
-- Lua: integer division // and % compute the tile offset.
local chiton = require("chiton")

return function(input) return chiton.lowest_risk(input, 5) end

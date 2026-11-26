-- Chiton, part 1: Dijkstra from top-left to bottom-right.
-- Lua: no heap in the stdlib, so buckets keyed by distance (fine for weights 1..9).
local chiton = require("chiton")

return function(input) return chiton.lowest_risk(input, 1) end

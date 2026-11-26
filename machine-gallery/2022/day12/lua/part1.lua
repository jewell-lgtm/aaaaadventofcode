-- Hill Climbing Algorithm, part 1: BFS from S to E.
-- Lua: no built-in queue, so an array plus a moving head index does the job.
local hill = require("hill")

return function(input)
  return hill.shortest_path(input, function(ch) return ch == "S" end)
end

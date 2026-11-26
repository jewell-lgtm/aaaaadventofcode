-- Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
-- Lua: the start predicate is just a closure.
local hill = require("hill")

return function(input)
  return hill.shortest_path(input, function(ch) return ch == "S" or ch == "a" end)
end

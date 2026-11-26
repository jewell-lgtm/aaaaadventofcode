-- Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
-- Lua: table.concat with a separator does the unfolding; counts fit in 64-bit integers.
local springs = require("springs")

return function(input) return springs.total(input, 5) end

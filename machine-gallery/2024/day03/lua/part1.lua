-- Mull It Over, part 1: Lua patterns have no {1,3}, so capture %d+ and check the length.
-- Lua: string.gmatch with captures; patterns are simpler than regex but enough here.
local function solve(input)
  local total = 0
  for a, b in input:gmatch("mul%((%d+),(%d+)%)") do
    if #a <= 3 and #b <= 3 then total = total + tonumber(a) * tonumber(b) end
  end
  return total
end

return solve

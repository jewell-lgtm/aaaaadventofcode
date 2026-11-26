-- Report Repair, part 1: a table used as a set; check each number's complement.
-- Lua: tables double as arrays and sets, gmatch pulls the numbers out.
local function solve(input)
  local seen = {}
  for n in input:gmatch("%d+") do
    n = tonumber(n)
    if seen[2020 - n] then return n * (2020 - n) end
    seen[n] = true
  end
  error("no pair sums to 2020")
end

return solve

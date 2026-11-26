-- Report Repair, part 2: nested loop over pairs, table lookup for the third.
-- Lua: plain numeric for-loops over an array table; counts guard against reusing an entry.
local function solve(input)
  local nums, count = {}, {}
  for n in input:gmatch("%d+") do
    n = tonumber(n)
    nums[#nums + 1] = n
    count[n] = (count[n] or 0) + 1
  end
  for i = 1, #nums do
    for j = i + 1, #nums do
      local a, b = nums[i], nums[j]
      local c = 2020 - a - b
      local need = 1 + (c == a and 1 or 0) + (c == b and 1 or 0)
      if (count[c] or 0) >= need then return a * b * c end
    end
  end
  error("no triple sums to 2020")
end

return solve

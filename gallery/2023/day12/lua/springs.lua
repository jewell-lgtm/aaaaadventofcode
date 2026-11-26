-- Shared: memoised recursion over (index, group), memo keyed by a single integer.
local aoc = require("aoc")
local M = {}

function M.arrangements(row, groups)
  local memo = {}
  local n = #row

  -- A damaged run of `size` can start at i: no '.' inside and not followed by '#'.
  local function fits(i, size)
    return i + size - 1 <= n
      and not row:sub(i, i + size - 1):find(".", 1, true)
      and row:sub(i + size, i + size) ~= "#"
  end

  local function count(i, g)
    if i > n then return g > #groups and 1 or 0 end
    local key = i * 1000 + g
    if memo[key] then return memo[key] end
    local c, total = row:sub(i, i), 0
    if c ~= "#" then total = total + count(i + 1, g) end
    local size = groups[g]
    if c ~= "." and size and fits(i, size) then total = total + count(i + size + 1, g + 1) end
    memo[key] = total
    return total
  end

  return count(1, 1)
end

function M.total(input, copies)
  local total = 0
  for _, line in ipairs(aoc.lines(input)) do
    local row, spec = line:match("(%S+) (%S+)")
    local rows, groups = {}, {}
    for k = 1, copies do
      rows[k] = row
      for n in spec:gmatch("%d+") do groups[#groups + 1] = tonumber(n) end
    end
    total = total + M.arrangements(table.concat(rows, "?"), groups)
  end
  return total
end

return M

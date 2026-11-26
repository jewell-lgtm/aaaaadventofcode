-- Shared: a table of pair counts; each rule AB -> C turns every AB into AC + CB.
local M = {}

local function add(t, k, n) t[k] = (t[k] or 0) + n end

function M.spread(input, steps)
  local template = input:match("^(%a+)")
  local rules = {}
  for pair, c in input:gmatch("(%a%a) %-> (%a)") do rules[pair] = c end

  local pairs_ = {}
  for i = 1, #template - 1 do add(pairs_, template:sub(i, i + 1), 1) end

  for _ = 1, steps do
    local nxt = {}
    for pair, n in pairs(pairs_) do
      local c = rules[pair]
      if c then
        add(nxt, pair:sub(1, 1) .. c, n)
        add(nxt, c .. pair:sub(2, 2), n)
      else
        add(nxt, pair, n)
      end
    end
    pairs_ = nxt
  end

  local elements = { [template:sub(-1)] = 1 }
  for pair, n in pairs(pairs_) do add(elements, pair:sub(1, 1), n) end
  local most, least = 0, math.maxinteger
  for _, n in pairs(elements) do most, least = math.max(most, n), math.min(least, n) end
  return most - least
end

return M

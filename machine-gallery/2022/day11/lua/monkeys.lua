-- Shared: parse each paragraph into a table with an op closure; simulate with a relief function.
local M = {}

function M.parse(input)
  local monkeys = {}
  for block in (input .. "\n\n"):gmatch("(.-)\n\n") do
    if block:find("Monkey") then
      local items = {}
      for n in block:match("items: ([%d, ]+)"):gmatch("%d+") do items[#items + 1] = tonumber(n) end
      local sym, rhs = block:match("old (.) (%w+)")
      local value = tonumber(rhs)
      monkeys[#monkeys + 1] = {
        items = items,
        op = function(old)
          local v = value or old
          if sym == "*" then return old * v else return old + v end
        end,
        divisor = tonumber(block:match("divisible by (%d+)")),
        if_true = tonumber(block:match("true: throw to monkey (%d+)")) + 1,
        if_false = tonumber(block:match("false: throw to monkey (%d+)")) + 1,
        inspected = 0,
      }
    end
  end
  return monkeys
end

function M.business(monkeys, rounds, relieve)
  for _ = 1, rounds do
    for _, m in ipairs(monkeys) do
      for _, item in ipairs(m.items) do
        local worry = relieve(m.op(item))
        local dest = monkeys[worry % m.divisor == 0 and m.if_true or m.if_false].items
        dest[#dest + 1] = worry
      end
      m.inspected = m.inspected + #m.items
      m.items = {}
    end
  end
  local counts = {}
  for i, m in ipairs(monkeys) do counts[i] = m.inspected end
  table.sort(counts, function(a, b) return a > b end)
  return counts[1] * counts[2]
end

return M

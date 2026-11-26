-- Shared: name -> number | {left, op, right}; an operator table of functions.
local aoc = require("aoc")
local M = {}

M.ops = {
  ["+"] = function(a, b) return a + b end,
  ["-"] = function(a, b) return a - b end,
  ["*"] = function(a, b) return a * b end,
  ["/"] = function(a, b) return a / b end,
}

function M.parse(input)
  local tree = {}
  for _, line in ipairs(aoc.lines(input)) do
    local name, left, op, right = line:match("(%w+): (%w+) (.) (%w+)")
    if name then tree[name] = { left, op, right }
    else
      local n, value = line:match("(%w+): (%d+)")
      tree[n] = tonumber(value)
    end
  end
  return tree
end

function M.evaluate(tree, name)
  local job = tree[name]
  if type(job) == "number" then return job end
  return M.ops[job[2]](M.evaluate(tree, job[1]), M.evaluate(tree, job[3]))
end

function M.depends_on(tree, name)
  if name == "humn" then return true end
  local job = tree[name]
  return type(job) == "table" and (M.depends_on(tree, job[1]) or M.depends_on(tree, job[3]))
end

-- Print floats that hold whole numbers as integers.
function M.whole(x) return math.tointeger(x) or string.format("%.0f", x) end

return M

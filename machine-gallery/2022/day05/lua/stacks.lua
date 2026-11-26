-- Shared parser and mover. Crate letters sit at columns 1 + 4i; read the drawing bottom-up.
local aoc = require("aoc")
local M = {}

function M.parse(input)
  local lines = aoc.lines(input)
  local blank
  for i, line in ipairs(lines) do
    if line == "" then blank = i break end
  end
  local stacks = {}
  for r = blank - 2, 1, -1 do
    for col, crate in lines[r]:gmatch("()%[(%a)%]") do
      local i = (col - 1) // 4 + 1
      stacks[i] = stacks[i] or {}
      table.insert(stacks[i], crate)
    end
  end
  local moves = {}
  for r = blank + 1, #lines do
    local n, from, to = lines[r]:match("move (%d+) from (%d+) to (%d+)")
    moves[#moves + 1] = { n = tonumber(n), from = tonumber(from), to = tonumber(to) }
  end
  return stacks, moves
end

-- Move n crates; keep_order = false reverses them (one at a time).
function M.run(input, keep_order)
  local stacks, moves = M.parse(input)
  for _, m in ipairs(moves) do
    local src, dst = stacks[m.from], stacks[m.to]
    local base = #src - m.n
    for k = 1, m.n do
      dst[#dst + 1] = keep_order and src[base + k] or src[#src - k + 1]
    end
    for k = #src, base + 1, -1 do src[k] = nil end
  end
  local tops = {}
  for i = 1, #stacks do tops[i] = stacks[i][#stacks[i]] or "" end
  return table.concat(tops)
end

return M

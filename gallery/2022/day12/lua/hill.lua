-- Shared: grid of byte heights, BFS with a head/tail index queue.
local aoc = require("aoc")
local M = {}

local function height(ch)
  if ch == "S" then ch = "a" elseif ch == "E" then ch = "z" end
  return ch:byte()
end

function M.shortest_path(input, is_start)
  local rows = aoc.lines(input)
  local queue, dist, head = {}, {}, 1
  local function key(r, c) return r * 100000 + c end
  for r, row in ipairs(rows) do
    for c = 1, #row do
      if is_start(row:sub(c, c)) then
        queue[#queue + 1] = { r, c }
        dist[key(r, c)] = 0
      end
    end
  end
  while head <= #queue do
    local r, c = table.unpack(queue[head])
    head = head + 1
    local here = rows[r]:sub(c, c)
    if here == "E" then return dist[key(r, c)] end
    for _, d in ipairs({ { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } }) do
      local nr, nc = r + d[1], c + d[2]
      local there = rows[nr] and rows[nr]:sub(nc, nc) or ""
      if there ~= "" and not dist[key(nr, nc)] and height(there) - height(here) <= 1 then
        dist[key(nr, nc)] = dist[key(r, c)] + 1
        queue[#queue + 1] = { nr, nc }
      end
    end
  end
  error("no path")
end

return M

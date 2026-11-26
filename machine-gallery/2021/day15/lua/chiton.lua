-- Shared: Dijkstra with a bucket queue (weights 1..9) over flat indices.
local aoc = require("aoc")
local M = {}

function M.lowest_risk(input, tiles)
  local base = {}
  for r, line in ipairs(aoc.lines(input)) do
    base[r - 1] = {}
    for c = 1, #line do base[r - 1][c - 1] = tonumber(line:sub(c, c)) end
  end
  local h, w = #base + 1, #base[0] + 1
  local H, W = h * tiles, w * tiles
  local function risk(r, c)
    return (base[r % h][c % w] + r // h + c // w - 1) % 9 + 1
  end

  local dist, buckets = { [0] = 0 }, { [0] = { 0 } }
  local d = 0
  while true do
    for _, p in ipairs(buckets[d] or {}) do
      local r, c = p // W, p % W
      if dist[p] == d then
        if r == H - 1 and c == W - 1 then return d end
        for _, n in ipairs({ { r + 1, c }, { r - 1, c }, { r, c + 1 }, { r, c - 1 } }) do
          local nr, nc = n[1], n[2]
          if nr >= 0 and nc >= 0 and nr < H and nc < W then
            local q, nd = nr * W + nc, d + risk(nr, nc)
            if not dist[q] or nd < dist[q] then
              dist[q] = nd
              buckets[nd] = buckets[nd] or {}
              table.insert(buckets[nd], q)
            end
          end
        end
      end
    end
    buckets[d] = nil
    d = d + 1
  end
end

return M

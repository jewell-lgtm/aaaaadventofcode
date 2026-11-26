-- Shared: compute a type score and rank list per hand, then table.sort with a comparator.
local aoc = require("aoc")
local M = {}

local function hand_type(hand, jokers)
  local counts, wild = {}, 0
  for c in hand:gmatch(".") do
    if jokers and c == "J" then wild = wild + 1 else counts[c] = (counts[c] or 0) + 1 end
  end
  local groups = {}
  for _, n in pairs(counts) do groups[#groups + 1] = n end
  table.sort(groups, function(a, b) return a > b end)
  groups[1] = (groups[1] or 0) + wild
  -- Largest group dominates, second group breaks ties (full house vs three, two pair vs pair).
  return groups[1] * 10 + (groups[2] or 0)
end

function M.winnings(input, order, jokers)
  local hands = {}
  for _, line in ipairs(aoc.lines(input)) do
    local hand, bid = line:match("(%S+)%s+(%d+)")
    local ranks = {}
    for c in hand:gmatch(".") do ranks[#ranks + 1] = order:find(c, 1, true) end
    hands[#hands + 1] = { type = hand_type(hand, jokers), ranks = ranks, bid = tonumber(bid) }
  end
  table.sort(hands, function(a, b)
    if a.type ~= b.type then return a.type < b.type end
    for i = 1, 5 do
      if a.ranks[i] ~= b.ranks[i] then return a.ranks[i] < b.ranks[i] end
    end
    return false
  end)
  local total = 0
  for rank, h in ipairs(hands) do total = total + rank * h.bid end
  return total
end

return M

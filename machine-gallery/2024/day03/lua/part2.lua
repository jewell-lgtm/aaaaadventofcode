-- Mull It Over, part 2: walk the string with string.find, taking whichever token comes next.
-- Lua: no alternation in patterns, so find the earliest of the three and advance the cursor.
local function next_token(s, pos)
  local best
  for _, kind in ipairs({ "mul%((%d+),(%d+)%)", "do%(%)", "don't%(%)" }) do
    local i, j, a, b = s:find(kind, pos)
    if i and (not best or i < best.i) then best = { i = i, j = j, kind = kind, a = a, b = b } end
  end
  return best
end

local function solve(input)
  local total, enabled, pos = 0, true, 1
  for tok in function() return next_token(input, pos) end do
    pos = tok.j + 1
    if tok.kind == "do%(%)" then enabled = true
    elseif tok.kind == "don't%(%)" then enabled = false
    elseif enabled and #tok.a <= 3 and #tok.b <= 3 then
      total = total + tonumber(tok.a) * tonumber(tok.b)
    end
  end
  return total
end

return solve

-- Harness helpers.
--   aoc.example: true when running an example (aoc test).
--   aoc.arg("size", 71): example-specific constant from examples.toml `args`, else the default.
local aoc = {}

aoc.example = os.getenv("AOC_EXAMPLE") == "1"

-- Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS.
local args = {}
for key, value in (os.getenv("AOC_ARGS") or ""):gmatch('"([^"]+)"%s*:%s*("?[^,}"]*"?)') do
  if value:sub(1, 1) == '"' then args[key] = value:sub(2, -2)
  elseif value == "true" or value == "false" then args[key] = value == "true"
  else args[key] = tonumber(value) end
end

function aoc.arg(name, default)
  local v = args[name]
  if v == nil then return default end
  return v
end

-- Split a string into lines (drops the trailing newline).
function aoc.lines(s)
  local out = {}
  for line in (s:gsub("\n+$", "") .. "\n"):gmatch("(.-)\n") do out[#out + 1] = line end
  return out
end

return aoc

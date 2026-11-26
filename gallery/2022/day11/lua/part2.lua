-- Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
-- Lua 5.4 has 64-bit integers, so values below modulus^2 (~1e14) stay exact.
local monkeys = require("monkeys")

return function(input)
  local ms = monkeys.parse(input)
  local modulus = 1
  for _, m in ipairs(ms) do modulus = modulus * m.divisor end
  return monkeys.business(ms, 10000, function(w) return w % modulus end)
end

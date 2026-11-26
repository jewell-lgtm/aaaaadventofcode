-- Camel Cards, part 1: rank hands by type, then card by card.
-- Lua: table.sort with a less-than comparator; string.find gives each card's strength.
local cards = require("cards")

return function(input) return cards.winnings(input, "23456789TJQKA", false) end

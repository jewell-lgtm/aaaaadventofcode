-- Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
-- Lua: same comparator; jokers are counted separately and added to the top group.
local cards = require("cards")

return function(input) return cards.winnings(input, "J23456789TQKA", true) end

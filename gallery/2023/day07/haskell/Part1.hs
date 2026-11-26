-- | Camel Cards: `sortOn` a key of (hand type, card strengths) and sum bid * rank.
--   The hand type is a pattern match on the group sizes, largest first.
--   With jokers, J is the weakest card and joins the biggest group.
module Part1 (solve, winnings) where

import Data.List (elemIndex, group, sort, sortOn)
import Data.Maybe (fromJust)
import Data.Ord (Down (..))

handType :: Bool -> String -> Int
handType joker cards = case addJokers (sortOn Down (map length (group (sort rest)))) of
  [5] -> 6
  [4, 1] -> 5
  [3, 2] -> 4
  [3, 1, 1] -> 3
  [2, 2, 1] -> 2
  [2, 1, 1, 1] -> 1
  _ -> 0
  where
    (jokers, rest) = if joker then (length (filter (== 'J') cards), filter (/= 'J') cards) else (0, cards)
    addJokers [] = [jokers] -- JJJJJ
    addJokers (biggest : others) = biggest + jokers : others

key :: Bool -> String -> (Int, [Int])
key joker hand = (handType joker hand, map strength hand)
  where
    order = if joker then "J23456789TQKA" else "23456789TJQKA"
    strength c = fromJust (elemIndex c order)

winnings :: Bool -> String -> Int
winnings joker input = sum (zipWith (*) [1 ..] (map snd ranked))
  where
    hands = [(hand, read bid) | [hand, bid] <- map words (lines input)]
    ranked = sortOn (key joker . fst) hands

solve :: String -> String
solve = show . winnings False

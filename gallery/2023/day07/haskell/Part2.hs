-- | Jokers: weakest for tie-breaks, wildcard for the hand type.
module Part2 (solve) where

import Part1 (winnings)

solve :: String -> String
solve = show . winnings True

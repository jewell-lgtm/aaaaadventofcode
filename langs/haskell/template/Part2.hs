module Part2 (solve) where

import Aoc (arg, example)
import qualified Data.Map.Strict as M

solve :: String -> String
solve input = show result
  where
    ls = lines input
    result = 0 :: Int

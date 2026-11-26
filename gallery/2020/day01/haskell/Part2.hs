-- | Fix each entry x via `tails`, then reuse part 1's pair search for 2020 - x on the rest.
--   The pattern `Just p <- [...]` filters failed searches inside the comprehension.
module Part2 (solve) where

import Data.List (tails)
import Data.Maybe (fromJust, listToMaybe)
import Part1 (pairProduct)

tripleProduct :: Int -> [Int] -> Maybe Int
tripleProduct target xs =
  listToMaybe [x * p | (x : rest) <- tails xs, Just p <- [pairProduct (target - x) rest]]

solve :: String -> String
solve = show . fromJust . tripleProduct 2020 . map read . lines

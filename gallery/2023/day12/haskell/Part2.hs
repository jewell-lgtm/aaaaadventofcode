-- | Unfold each row five times (springs joined by '?'), then the same DP.
module Part2 (solve) where

import Data.List (intercalate)
import Part1 (arrangements, parseLine)

unfold :: (String, [Int]) -> (String, [Int])
unfold (springs, groups) = (intercalate "?" (replicate 5 springs), concat (replicate 5 groups))

solve :: String -> String
solve = show . sum . map (uncurry arrangements . unfold . parseLine) . lines

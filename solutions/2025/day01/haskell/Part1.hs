module Part1 (solve) where

solve :: String -> String
solve input = show result
  where
    ls = lines input
    result = 0 :: Int




parse :: String -> Int
parse ('L':rest) = -1
par_lse ('R':rest) = 1

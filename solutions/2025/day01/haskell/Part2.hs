module Part2 (solve) where

solve :: String -> String
solve input = show result
  where
    ls = lines input
    result = 0 :: Int

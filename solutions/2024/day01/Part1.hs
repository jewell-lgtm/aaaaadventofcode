module Part1 (solve) where

import Data.List (sort)

solve :: String -> String
solve input = show result
  where
    pairs = map (map read . words) $ lines input :: [[Int]]
    (left, right) = let (l, r) = unzip [(a, b) | [a, b] <- pairs] in (sort l, sort r)
    result = sum $ zipWith (\l r -> abs (l - r)) left right

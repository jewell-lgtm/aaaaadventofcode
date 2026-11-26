module Part2 (solve) where

import Data.List (sort)

solve :: String -> String
solve input = show result
  where
    pairs = map (map read . words) $ lines input :: [[Int]]
    (left, right) = let (l, r) = unzip [(a, b) | [a, b] <- pairs] in (sort l, sort r)
    count x = length $ filter (== x) right
    result = sum $ map (\x -> x * count x) left

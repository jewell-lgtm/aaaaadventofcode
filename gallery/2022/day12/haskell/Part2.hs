-- | Search backwards from E with the step rule reversed; stop at the first 'a'.
module Part2 (solve) where

import Part1 (bfs, find, height, parse)

solve :: String -> String
solve input = maybe "unreachable" show $ bfs g down ((== fromEnum 'a') . height g) (find 'E' g)
  where
    g = parse input
    down a b = height g a <= height g b + 1

-- | 40 steps: the pair map stays tiny, so this is as fast as part 1.
module Part2 (solve) where

import Part1 (spread)

solve :: String -> String
solve = show . spread 40

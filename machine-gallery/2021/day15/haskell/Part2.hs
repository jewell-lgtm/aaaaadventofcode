-- | Tile the cave 5x5: each tile step adds 1 to the risk, wrapping 9 back to 1.
module Part2 (solve) where

import Part1 (Cave (..), lowestRisk, parse)

tiled :: Cave -> Cave
tiled (Cave h w risk) = Cave (5 * h) (5 * w) risk'
  where
    risk' (r, c) = (risk (r `mod` h, c `mod` w) + r `div` h + c `div` w - 1) `mod` 9 + 1

solve :: String -> String
solve = show . lowestRisk . tiled . parse

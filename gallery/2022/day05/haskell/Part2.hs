-- | The CrateMover 9001 moves crates as a block, so the lifted order is kept.
module Part2 (solve) where

import Part1 (run)

solve :: String -> String
solve = run id

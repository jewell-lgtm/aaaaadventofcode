-- | Extended Polymerization: never build the polymer. Count adjacent pairs in a Map;
--   each step, pair AB with rule C becomes AC and CB (`M.fromListWith (+)` regroups).
--   Element counts = first letter of each pair, plus the template's last letter.
module Part1 (solve, spread) where

import qualified Data.Map.Strict as M

spread :: Int -> String -> Int
spread steps input = maximum counts - minimum counts
  where
    template : _ : ruleLines = lines input
    rules = M.fromList [((a, b), c) | [[a, b], "->", [c]] <- map words ruleLines]
    start = M.fromListWith (+) [(p, 1) | p <- zip template (tail template)]
    step pairs =
      M.fromListWith (+) $
        concat
          [ maybe [(p, n)] (\c -> [((a, c), n), ((c, b), n)]) (M.lookup p rules)
          | (p@(a, b), n) <- M.toList pairs ]
    final = iterate step start !! steps
    counts = M.elems $ M.fromListWith (+) ((last template, 1) : [(a, n) | ((a, _), n) <- M.toList final])

solve :: String -> String
solve = show . spread 10
